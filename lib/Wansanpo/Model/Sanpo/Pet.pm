package Wansanpo::Model::Sanpo::Pet;
use Mojo::Base 'Wansanpo::Model::Base';
use Mojo::Util qw{dumper};

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo::pet - コントローラーモデル

=cut

has [qw{}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Sanpo::pet!!';
}

# 簡易バリデート
sub easy_validate {
    my $self   = shift;
    my $params = $self->req_params;
    return if !$params->{type};
    return if !$params->{name};
    return if !$params->{gender};
    return 1;
}

# ログイン者であることの確認
sub is_login_user {
    my $self    = shift;
    my $user_id = shift;
    my $pet_id  = $self->req_params->{id};
    return if !$user_id;
    return if !$pet_id;
    my $cond = +{
        id      => $pet_id,
        user_id => $user_id,
        deleted => 0,
    };
    my $pet_row = $self->db->teng->single( 'pet', $cond );
    return if !$pet_row;
    return 1;
}

# 登録実行
sub store {
    my $self   = shift;
    my $master = $self->db->master;
    my $params = +{
        user_id  => $self->req_params->{user_id},
        type     => $self->req_params->{type},
        name     => $self->req_params->{name},
        gender   => $self->req_params->{gender},
        icon     => '',
        birthday => $self->req_params->{birthday},
        note     => $self->req_params->{note},
        deleted  => $master->deleted->constant('NOT_DELETED'),
    };
    return $self->db->teng_fast_insert( 'pet', $params );
}

# 更新実行
sub update {
    my $self   = shift;
    my $pet_id = $self->req_params->{id};
    my $params = +{ %{ $self->req_params }, };
    delete $params->{id};
    my $cond = +{ id => $pet_id };
    my $update_id = $self->db->teng_update( 'pet', $params, $cond );
    return $update_id;
}

# アイコン更新実行
sub update_icon {
    my $self       = shift;
    my $pet_id = $self->req_params->{id};
    my $params     = +{ %{ $self->req_params }, };
    delete $params->{id};
    my $cond = +{ id => $pet_id };
    my $update_id = $self->db->teng_update( 'pet', $params, $cond );
    return $update_id;
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
    my $self   = shift;
    my $pet_id = $self->req_params->{id};
    return if !$pet_id;

    my $cond = +{
        id      => $pet_id,
        deleted => 0,
    };
    my $pet_row = $self->db->teng->single( 'pet', $cond );
    return if !$pet_row;

    # ペット情報、ログインID
    my $pet_hash_ref     = $pet_row->get_columns;
    my $user_hash_ref    = $pet_row->fetch_user->get_columns;
    my $profile_hash_ref = $pet_row->fetch_user->fetch_profile->get_columns;

    my $master     = $self->db->master;
    my $gender_pet = $master->gender_pet->word( $pet_hash_ref->{gender} );
    $pet_hash_ref->{gender_word} = $gender_pet;
    my $gender = $master->gender->word( $profile_hash_ref->{gender} );
    $profile_hash_ref->{gender_word} = $gender;
    return +{
        user    => $user_hash_ref,
        profile => $profile_hash_ref,
        pet     => $pet_hash_ref,
    };
}

sub to_template_search {
    my $self = shift;

    my $cond = +{ deleted => 0, };
    my @pet_rows = $self->db->teng->search( 'pet', $cond );
    return if !scalar @pet_rows;

    # 飼い主の情報を追記
    # my $pets_hash_ref = [ map { $_->get_columns } @pet_rows ];

    my $pets_hash_ref = [];
    for my $pet_row (@pet_rows) {
        my $profile_hash_ref
            = $pet_row->fetch_user->fetch_profile->get_columns;
        my $hash = $pet_row->get_columns;
        $hash->{address} = $profile_hash_ref->{address};
        $hash->{email}   = $profile_hash_ref->{email};
        push @{$pets_hash_ref}, $hash;
    }

    # 3の倍数になっているか
    while (1) {
        my $rows   = scalar @{$pets_hash_ref};
        my $result = $rows % 3;
        last if $result eq 0;
        push @{$pets_hash_ref}, +{};
    }

    # こんな感じに
    # [
    #     [+{},+{},+{},],
    #     [+{},+{},+{},],
    #     ... ,
    # ]
    my $pets = [];
    my $line = [];
    while ( my $row = shift @{$pets_hash_ref} ) {
        push @{$line}, $row;
        my $count  = scalar @{$line};
        my $result = $count % 3;
        if ( $result eq 0 ) {
            push @{$pets}, $line;
            $line = [];
            next;
        }
    }
    return +{ pets => $pets, };
}

# テンプレ新規登録
sub to_template_create {
    my $self = shift;

    my $user_id = $self->req_params->{user_id};
    return if !$user_id;

    my $cond = +{
        id      => $user_id,
        deleted => 0,
    };
    my $user_row = $self->db->teng->single( 'user', $cond );
    return if !$user_row;

    # ログインID
    my $user_hash_ref    = $user_row->get_columns;
    my $profile_hash_ref = $user_row->fetch_profile->get_columns;

    return +{
        user    => $user_hash_ref,
        profile => $profile_hash_ref,
    };
}

1;

__END__
