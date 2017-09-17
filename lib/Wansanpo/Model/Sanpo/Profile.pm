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

1;

__END__
