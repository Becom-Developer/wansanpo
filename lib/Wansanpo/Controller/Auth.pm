package Wansanpo::Controller::Auth;
use Mojo::Base 'Wansanpo::Controller';

# ユーザ登録画面
sub entry {
    my $self = shift;
    $self->stash(
        class_active => +{
            wansanpo => 'active',
            entry    => 'active',
        }
    );
    $self->render(
        template => 'auth/entry',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

# ユーザー登録実行
sub store_entry {
    my $self       = shift;
    my $params     = $self->req->params->to_hash;
    my $auth_model = $self->model->auth->req_params($params);
    $self->stash(
        class_active => +{
            wansanpo => 'active',
            entry    => 'active',
        },
        msg      => '登録できません',
        template => 'auth/entry',
        format   => 'html',
        handler  => 'ep',
    );

    # 簡易的なバリデート
    return $self->render if !$auth_model->easy_validate;

    # 登録実行
    $auth_model->exec_entry;

    # 書き込み保存終了、リダイレクト終了
    $self->flash( msg => 'ユーザー登録完了しました' );
    $self->redirect_to('/auth/entry');
    return;
}

# ログイン画面
sub login {
    my $self = shift;
    $self->render(
        template => 'auth/login',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

# ログイン確認実行
sub check_login {
    my $self       = shift;
    my $params     = $self->req->params->to_hash;
    my $auth_model = $self->model->auth->req_params($params);

    $self->stash(
        msg      => 'ユーザーが存在しません',
        template => 'auth/login',
        format   => 'html',
        handler  => 'ep',
    );

    # DB 存在確認
    my $login_user = $auth_model->check;
    return $self->render if !$login_user;

    # 認証
    $self->session( user => $params->{login_id} );

    # 始めてのログインはプロフィールへ
    if ( $login_user->is_first_login ) {
        my $profile_id = $login_user->fetch_profile->id;
        $self->flash(
            msg => 'プロフィールを登録してください' );
        $self->redirect_to("/sanpo/profile/$profile_id/edit");
        return;
    }

    $self->flash( msg => 'ユーザーログインしました' );
    $self->redirect_to('/sanpo/menu');
    return;
}

# ログイン状態の確認
sub logged_in {
    my $self = shift;
    return 1 if $self->session('user');
    return;
}

# ログアウト実行
sub logout {
    my $self = shift;
    $self->session( expires => 1 );
    $self->redirect_to('/info/intro');
    return;
}

1;

__END__
