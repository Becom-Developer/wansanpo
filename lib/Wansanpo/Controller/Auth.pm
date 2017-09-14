package Wansanpo::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

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
    my $self = shift;

    # DB 存在確認

    # 登録実行

    # 書き込み保存終了、リダイレクト終了
    $self->flash( flash_msg => 'ユーザー登録完了しました' );
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

# TODO: ログイン実行 (メソッド名は考え直す)
sub store_login {
    my $self = shift;

    # DB 存在確認

    # 認証

    # 書き込み保存終了、リダイレクト終了
    $self->flash( flash_msg => 'ユーザーログインしました' );
    $self->redirect_to('/');

    # メニュー画面できたら遷移
    # $self->redirect_to('/sanpo/menu');
    return;
}



sub logout {
    my $self = shift;
    $self->render(text => 'test logout');
    return;
}

1;

__END__
