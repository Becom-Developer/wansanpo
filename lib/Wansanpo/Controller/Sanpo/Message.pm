package Wansanpo::Controller::Sanpo::Message;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# テンプレ用共通スタッシュ
sub _template_common {
    my $self     = shift;
    my $template = shift;
    my $msg      = shift;
    return +{
        class_active => +{
            wansanpo => 'active',
            message  => 'active',
        },
        msg      => $msg,
        template => $template,
        format   => 'html',
        handler  => 'ep',
    };
}

# メッセージ詳細
sub show {
    my $self = shift;
    $self->render( text => 'show' );
    return;
}

# メッセージを新規作成する画面
sub create {
    my $self = shift;
    $self->render( text => 'create' );
    return;
}

# メッセージ新規登録実行
sub store {
    my $self = shift;
    $self->render( text => 'store' );
    return;
}

# メッセージを編集する画面
sub edit {
    my $self = shift;
    $self->render( text => 'edit' );
    return;
}

# メッセージを更新実行
sub update {
    my $self = shift;
    $self->render( text => 'update' );
    return;
}

# メッセージ情報検索画面
sub search {
    my $self = shift;

    my $params = +{ user_id => $self->login_user->id, };

    # 今回は検索機能は実装しない
    my $model = $self->model->sanpo->message->req_params($params);
    $self->stash( $model->to_template_search );
    $self->stash( $self->_template_common('sanpo/message/search') );
    $self->render;
    return;
}

# メッセージ情報ユーザー個別に一覧表示
sub list {
    my $self = shift;
    $self->render( text => 'list' );
    return;
}

# メッセージ情報削除
sub remove {
    my $self = shift;
    $self->render( text => 'remove' );
    return;
}

1;

__END__
