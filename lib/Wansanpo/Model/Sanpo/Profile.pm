package Wansanpo::Model::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Model::Base';
use Mojo::Util qw{dumper};
use Wansanpo::Util qw{now_datetime};

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo::Profile - コントローラーモデル

=cut

has [qw{}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Sanpo::Profile!!';
}

# 簡易バリデート
sub easy_validate {
    my $self   = shift;
    my $params = $self->req_params;
    return if !$params->{id};
    return if !$params->{name};
    return if !$params->{email};
    return 1;
}

# 更新実行
sub update {
    my $self       = shift;
    my $profile_id = $self->req_params->{id};
    my $params     = +{ %{ $self->req_params }, };
    delete $params->{id};
    my $cond = +{ id => $profile_id };
    $self->db->teng_update( 'profile', $params, $cond );
    return;
}

# ログイン者であることの確認
sub is_login_user {
    my $self       = shift;
    my $user_id    = shift;
    my $profile_id = $self->req_params->{id};
    return if !$user_id;
    return if !$profile_id;
    my $cond = +{
        id      => $profile_id,
        user_id => $user_id,
        deleted => 0,
    };
    my $profile_row = $self->db->teng->single( 'profile', $cond );
    return if !$profile_row;
    return 1;
}

# テンプレ一覧用値取得
sub to_template_show {
    my $self = shift;
    return $self->_to_template_common;
}

# テンプレ編集用値取得
sub to_template_edit {
    my $self = shift;
    return $self->_to_template_common;
}

# テンプレ用値取得共通
sub _to_template_common {
    my $self       = shift;
    my $profile_id = $self->req_params->{id};
    return if !$profile_id;

    my $cond = +{
        id      => $profile_id,
        deleted => 0,
    };
    my $profile_row = $self->db->teng->single( 'profile', $cond );
    return if !$profile_row;

    # ペット情報、ログインID
    my $profile_hash_ref = $profile_row->get_columns;
    my $user_hash_ref    = $profile_row->fetch_user->get_columns;
    my $pet_rows         = $profile_row->search_pet;
    my $pers_hash_ref    = [ map { $_->get_columns } @{$pet_rows} ];

    # 入力されていない場合もある
    if ( $profile_hash_ref->{gender} ) {
        my $master = $self->db->master;
        $profile_hash_ref->{gender_word}
            = $master->gender->word( $profile_hash_ref->{gender} );
    }

    return +{
        user    => $user_hash_ref,
        pets    => $pers_hash_ref,
        profile => $profile_hash_ref,
    };
}

sub to_template_search {
    my $self = shift;

    my $cond = +{ deleted => 0, };
    my @profile_rows = $self->db->teng->search( 'profile', $cond );
    return if !scalar @profile_rows;

    my $profiles_hash_ref = [ map { $_->get_columns } @profile_rows ];

    # 3の倍数になっているか
    while (1) {
        my $rows   = scalar @{$profiles_hash_ref};
        my $result = $rows % 3;
        last if $result eq 0;
        push @{$profiles_hash_ref}, +{};
    }

    # こんな感じに
    # [
    #     [+{},+{},+{},],
    #     [+{},+{},+{},],
    #     ... ,
    # ]
    my $profiles = [];
    my $line     = [];
    while ( my $row = shift @{$profiles_hash_ref} ) {
        push @{$line}, $row;
        my $count  = scalar @{$line};
        my $result = $count % 3;
        if ( $result eq 0 ) {
            push @{$profiles}, $line;
            $line = [];
            next;
        }
    }
    return +{ profiles => $profiles, };
}

1;

__END__
