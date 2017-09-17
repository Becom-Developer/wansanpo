package Wansanpo::Model::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Model::Base';
use Mojo::Util qw{dumper};

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

    my $master = $self->db->master;
    my $gender = $master->gender->word( $profile_hash_ref->{gender} );
    $profile_hash_ref->{gender_word} = $gender;

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
