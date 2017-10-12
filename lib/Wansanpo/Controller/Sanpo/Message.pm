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

    my $params = +{
        from_user_id      => $self->login_user->id,
        firend_profile_id => $self->stash->{id},
    };

    my $model = $self->model->sanpo->message->req_params($params);
    my $to_template_create = $model->to_template_create;

    # パラメータの取得に失敗時はメニューへ
    if ( !$to_template_create ) {
        $self->flash( msg => '不正な入力' );
        $self->redirect_to("/sanpo/menu");
        return;
    }
    $self->stash($to_template_create);
    $self->stash( $self->_template_common('sanpo/message/create') );
    $self->render;
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

    my $params = +{
        id      => $self->stash->{id},
        user_id => $self->login_user->id,
    };

    my $model            = $self->model->sanpo->message->req_params($params);
    my $to_template_list = $model->to_template_list;

    # パラメータの取得に失敗時はメニューへ
    if ( !$to_template_list ) {
        $self->flash( msg => '不正な入力' );
        $self->redirect_to("/sanpo/menu");
        return;
    }
    $self->stash($to_template_list);
    $self->stash( $self->_template_common('sanpo/message/list') );
    $self->render;
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
