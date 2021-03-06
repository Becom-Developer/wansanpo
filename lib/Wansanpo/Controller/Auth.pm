package Wansanpo::Controller::Auth;
use Mojo::Base 'Wansanpo::Controller::Base';

# テンプレ用共通スタッシュ
sub _template_common {
    my $self     = shift;
    my $template = shift;
    my $msg      = shift;
    return +{
        class_active => +{
            wansanpo => 'active',
            entry    => 'active',
        },
        msg      => $msg,
        template => $template,
        format   => 'html',
        handler  => 'ep',
    };
}

# ユーザ登録画面
sub create {
    my $self = shift;
    $self->stash( $self->_template_common('auth/entry') );
    $self->render;
    return;
}

# ユーザー登録実行
sub store {
    my $self   = shift;
    my $params = $self->req->params->to_hash;
    my $model  = $self->model->auth->req_params($params);
    my $msg    = '登録できません';
    $self->stash( $self->_template_common( 'auth/entry', $msg ) );

    # 簡易的なバリデート
    return $self->render if !$model->easy_validate;

    # 登録実行
    $model->store;

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
sub check {
    my $self   = shift;
    my $params = $self->req->params->to_hash;
    my $model  = $self->model->auth->req_params($params);

    $self->stash(
        msg      => 'ユーザーが存在しません',
        template => 'auth/login',
        format   => 'html',
        handler  => 'ep',
    );

    # DB 存在確認
    my $login_user = $model->check;
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

# パスワード変更画面
sub edit {
    my $self = shift;
    $self->render( text => 'edit' );
    return;
}

# パスワード変更実行
sub update {
    my $self = shift;
    $self->render( text => 'update' );
    return;
}

1;

__END__
