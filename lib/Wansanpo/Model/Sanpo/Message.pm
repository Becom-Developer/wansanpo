package Wansanpo::Model::Sanpo::Message;
use Mojo::Base 'Wansanpo::Model::Base';
use Mojo::Util qw{dumper};
use Mojo::Collection;

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo::Message - コントローラーモデル

=cut

has [qw{}];

# # 簡易バリデート
# sub easy_validate {
#     my $self   = shift;
#     my $params = $self->req_params;
#     return if !$params->{type};
#     return if !$params->{name};
#     return if !$params->{gender};
#     return 1;
# }

# # ログイン者であることの確認
# sub is_login_user {
#     my $self    = shift;
#     my $user_id = shift;
#     my $message_id  = $self->req_params->{id};
#     return if !$user_id;
#     return if !$message_id;
#     my $cond = +{
#         id      => $message_id,
#         user_id => $user_id,
#         deleted => 0,
#     };
#     my $message_row = $self->db->teng->single( 'message', $cond );
#     return if !$message_row;
#     return 1;
# }

# # 登録実行
# sub store {
#     my $self   = shift;
#     my $master = $self->db->master;
#     my $params = +{
#         user_id  => $self->req_params->{user_id},
#         type     => $self->req_params->{type},
#         name     => $self->req_params->{name},
#         gender   => $self->req_params->{gender},
#         icon     => '',
#         birthday => $self->req_params->{birthday},
#         note     => $self->req_params->{note},
#         deleted  => $master->deleted->constant('NOT_DELETED'),
#     };
#     return $self->db->teng_fast_insert( 'message', $params );
# }

# # 更新実行
# sub update {
#     my $self   = shift;
#     my $message_id = $self->req_params->{id};
#     my $params = +{ %{ $self->req_params }, };
#     delete $params->{id};
#     my $cond = +{ id => $message_id };
#     my $update_id = $self->db->teng_update( 'message', $params, $cond );
#     return $update_id;
# }

# # テンプレ一覧用値取得
# sub to_template_show {
#     my $self = shift;
#     return $self->_to_template_common;
# }

# # テンプレ編集用値取得
# sub to_template_edit {
#     my $self = shift;
#     return $self->_to_template_common;
# }

# # テンプレ用値取得共通
# sub _to_template_common {
#     my $self   = shift;
#     my $message_id = $self->req_params->{id};
#     return if !$message_id;

#     my $cond = +{
#         id      => $message_id,
#         deleted => 0,
#     };
#     my $message_row = $self->db->teng->single( 'message', $cond );
#     return if !$message_row;

#     # ペット情報、ログインID
#     my $message_hash_ref     = $message_row->get_columns;
#     my $user_hash_ref    = $message_row->fetch_user->get_columns;
#     my $profile_hash_ref = $message_row->fetch_user->fetch_profile->get_columns;

#     my $master     = $self->db->master;
#     my $gender_message = $master->gender_message->word( $message_hash_ref->{gender} );
#     $message_hash_ref->{gender_word} = $gender_message;
#     my $gender = $master->gender->word( $profile_hash_ref->{gender} );
#     $profile_hash_ref->{gender_word} = $gender;
#     return +{
#         user    => $user_hash_ref,
#         profile => $profile_hash_ref,
#         message     => $message_hash_ref,
#     };
# }

sub to_template_search {
    my $self = shift;
    my $cond = +{ id => $self->req_params->{user_id}, deleted => 0, };
    my $row  = $self->db->teng->single( 'user', $cond, );

    # メッセージ履歴のあるユーザー情報を取得
    my $rows = $row->search_msg_friend_user;
    my $msg_friends;
    for my $row ( @{$rows} ) {
        push @{$msg_friends},
            +{
            user    => $row->get_columns,
            profile => $row->fetch_profile->get_columns,
            };
    }
    return +{ msg_friends => $msg_friends };
}

sub to_template_list {
    my $self = shift;

    my $cond = +{ id => $self->req_params->{user_id}, deleted => 0, };
    my $row = $self->db->teng->single( 'user', $cond, );

    # ログイン者の情報
    my $user_profile  = $row->fetch_profile;
    my $login_user_id = $row->id;

    # 相手の情報
    $cond = +{ id => $self->req_params->{id}, deleted => 0, };
    my $firend_profile = $self->db->teng->single( 'profile', $cond, );

    # 無効なユーザーの場合は終了
    return if !$firend_profile;

    my $firend_profile_hash = $firend_profile->get_columns;
    my $firend_user_id      = $firend_profile->user_id;

    # メッセージ履歴を取得
    my $rows = $row->search_msg_history($firend_user_id);

    # 名前情報を含める
    my $message_data = [];
    for my $row ( @{$rows} ) {
        my $to_user         = $row->fetch_to_user_row;
        my $to_user_profile = $to_user->fetch_profile;

        my $from_user         = $row->fetch_from_user_row;
        my $from_user_profile = $from_user->fetch_profile;

        my $is_from_msg;
        if ( $row->from_user_id eq $login_user_id ) {
            $is_from_msg = 1;
        }
        push @{$message_data},
            +{
            is_from_msg => $is_from_msg,
            message     => $row->get_columns,
            to_user     => +{
                user    => $to_user->get_columns,
                profile => $to_user_profile->get_columns,
            },
            from_user => +{
                user    => $from_user->get_columns,
                profile => $from_user_profile->get_columns,
            },
            };
    }
    return +{
        firend_profile => $firend_profile_hash,
        messages       => $message_data,
    };
}

# テンプレ新規登録
sub to_template_create {
    my $self = shift;

    # 送る人の情報 ログインしている人
    my $cond = +{
        id      => $self->req_params->{from_user_id},
        deleted => 0,
    };
    my $from_user = $self->db->teng->single( 'user', $cond );
    return if !$from_user;

    my $from_user_hash_ref = +{
        user    => $from_user->get_columns,
        profile => $from_user->fetch_profile->get_columns,
    };

    # 送り先の情報 指定された profile_id
    $cond = +{
        id      => $self->req_params->{firend_profile_id},
        deleted => 0,
    };
    my $to_profile = $self->db->teng->single( 'profile', $cond );
    return if !$to_profile;

    my $to_user_hash_ref = +{
        user    => $to_profile->fetch_user->get_columns,
        profile => $to_profile->get_columns,
    };

    return +{
        to_user   => $to_user_hash_ref,
        from_user => $from_user_hash_ref,
    };
}

1;

__END__
