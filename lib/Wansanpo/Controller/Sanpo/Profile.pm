package Wansanpo::Controller::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Controller::Base';

# テンプレ用共通スタッシュ
sub _template_common {
    my $self     = shift;
    my $template = shift;
    my $msg      = shift;
    return +{
        class_active => +{
            wansanpo => 'active',
            profile  => 'active',
        },
        msg      => $msg,
        template => $template,
        format   => 'html',
        handler  => 'ep',
    };
}

# ユーザー情報詳細
sub show {
    my $self = shift;

    my $params = +{ id => $self->stash->{id}, };
    my $model = $self->model->sanpo->profile->req_params($params);

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user    = $model->is_login_user( $self->login_user->id );
    my $to_template_show = $model->to_template_show;

    # パラメータの取得に失敗時はメニューへ
    return $self->redirect_to_error if !$to_template_show;

    $self->stash($to_template_show);
    $self->stash( is_login_user => $is_login_user );
    $self->stash( $self->_template_common('sanpo/profile/show') );
    $self->render;
    return;
}

# ユーザー情報編集画面
sub edit {
    my $self = shift;

    my $params = +{ id => $self->stash->{id}, };
    my $model = $self->model->sanpo->profile->req_params($params);

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user    = $model->is_login_user( $self->login_user->id );
    my $template         = 'sanpo/profile/edit';
    my $to_template_edit = $model->to_template_edit;

    # パラメータの取得に失敗時はメニューへ
    return $self->redirect_to_error if !$to_template_edit;

    $self->stash($to_template_edit);
    $self->stash( is_login_user => $is_login_user );
    $self->stash( $self->_template_common($template) );
    my $profile_params = $model->to_template_edit->{profile};
    $self->render_fillin( $template, $profile_params );
    return;
}

# ユーザー情報検索(お仲間)
sub search {
    my $self = shift;

    # 今回は検索機能は実装しない
    my $model = $self->model->sanpo->profile;
    $self->stash( $model->to_template_search );
    $self->stash( $self->_template_common('sanpo/profile/search') );
    $self->render;
    return;
}

# ユーザー情報更新実行
sub update {
    my $self   = shift;
    my $params = $self->req->params->to_hash;

    # アイコンアップデート
    if ( $self->req->upload('icon') ) {
        $self->_update_icon;
        return;
    }

    $params->{id} = $self->stash->{id};
    my $model            = $self->model->sanpo->profile->req_params($params);
    my $msg              = '更新できません';
    my $is_login_user    = $model->is_login_user( $self->login_user->id );
    my $template         = 'sanpo/profile/edit';
    my $to_template_edit = $model->to_template_edit;

    # パラメータの取得に失敗時はメニューへ
    return $self->redirect_to_error if !$to_template_edit;

    $self->stash($to_template_edit);
    $self->stash( is_login_user => $is_login_user );
    $self->stash( $self->_template_common( $template, $msg ) );

    # 簡易的なバリデート
    return $self->render_fillin( $template, $params )
        if !$model->easy_validate;

    # 実行
    my $update_id = $model->update;

    # 書き込み保存終了、リダイレクト終了
    $self->flash( msg => 'ユーザー更新完了しました' );
    $self->redirect_to("/sanpo/profile/$update_id");
    return;
}

# アイコンアップデート
sub _update_icon {
    my $self         = shift;
    my $update_id    = $self->stash->{id};
    my $redirect_url = "/sanpo/profile/$update_id";

    # icon アップロードアクション
    my $save_filename = $self->upload_icon($redirect_url);

    # ファイル名DB更新
    my $params = +{
        id   => $update_id,
        icon => $save_filename,
    };
    my $model = $self->model->sanpo->profile->req_params($params);
    $model->update_icon;

    # 書き込み保存終了、リダイレクト終了
    $self->flash( msg => 'アイコンを更新しました' );
    $self->redirect_to($redirect_url);
    return;
}

# ユーザー情報削除(退会)
sub remove {
    my $self = shift;
    $self->render( text => 'remove' );
    return;
}

1;

__END__
