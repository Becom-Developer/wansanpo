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

# テンプレ一覧用値取得
sub to_template_show {
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

1;

__END__
