package Wansanpo::Model::Auth;
use Mojo::Base 'Wansanpo::Model::Base';
use Wansanpo::Util qw{now_datetime};
use Data::Dumper;

=encoding utf8

=head1 NAME

Wansanpo::Model::Auth - コントローラーモデル

=cut

has [qw{}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Auth!!';
}

# 簡易バリデート
sub easy_validate {
    my $self   = shift;
    my $params = $self->req_params;
    return if !$params->{login_id};
    return if !$params->{password};

    # 二重登録防止
    my $cond = +{
        login_id => $params->{login_id},
        deleted  => $self->db->master->deleted->constant('NOT_DELETED'),
    };
    my $user = $self->db->teng->single( 'user', $cond );
    return if $user;
    return 1;
}

# 登録実行
sub store {
    my $self   = shift;
    my $master = $self->db->master;

    my $user_params = +{
        login_id  => $self->req_params->{login_id},
        password  => $self->req_params->{password},
        approved  => $master->approved->constant('APPROVED'),
        authority => $master->authority->constant('CUSTOMER'),
        deleted   => $master->deleted->constant('NOT_DELETED'),
    };

    my $txn = $self->db->teng->txn_scope;

    my $user_id = $self->db->teng_fast_insert( 'user', $user_params );

    my $profile_params = +{
        user_id => $user_id,
        email   => $self->req_params->{login_id},
        deleted => 0,
    };
    my $profile_id = $self->db->teng_fast_insert( 'profile', $profile_params );

    $txn->commit;
    return;
}

# DB 認証
sub check {
    my $self   = shift;
    my $params = $self->req_params;
    my $cond   = +{
        login_id => $params->{login_id},
        password => $params->{password},
        deleted  => $self->db->master->deleted->constant('NOT_DELETED'),
    };
    my $user = $self->db->teng->single( 'user', $cond );
    return $user if $user;
    return;
}

# セッション用確認
sub session_check {
    my $self   = shift;
    my $params = $self->req_params;
    my $cond   = +{
        login_id => $params->{login_id},
        deleted  => $self->db->master->deleted->constant('NOT_DELETED'),
    };
    my $user = $self->db->teng->single( 'user', $cond );
    return $user if $user;
    return;
}

1;

__END__
