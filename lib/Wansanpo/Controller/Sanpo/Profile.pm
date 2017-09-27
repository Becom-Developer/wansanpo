package Wansanpo::Controller::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# テンプレ用共通スタッシュ
sub _template_common {
    my $self     = shift;
    my $template = shift;

    return +{
        class_active => +{
            wansanpo => 'active',
            profile  => 'active',
        },
        template => $template,
        format   => 'html',
        handler  => 'ep',
    };
}

# ユーザー情報詳細
sub show {
    my $self = shift;

    my $params = +{id => $self->stash->{id},};
    my $profile_model = $self->model->sanpo->profile->req_params($params);

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user = $profile_model->is_login_user($self->login_user->id);
    $self->stash($profile_model->to_template_show);
    $self->stash(is_login_user => $is_login_user);
    $self->stash($self->_template_common('sanpo/profile/show'));
    $self->render;
    return;
}

# ユーザー情報編集画面
sub edit {
    my $self = shift;

    my $params = +{id => $self->stash->{id},};
    my $profile_model = $self->model->sanpo->profile->req_params($params);

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user = $profile_model->is_login_user($self->login_user->id);
    my $template = 'sanpo/profile/edit';
    $self->stash($profile_model->to_template_edit);
    $self->stash(is_login_user => $is_login_user);
    $self->stash($self->_template_common($template));
    my $profile_params = $profile_model->to_template_edit->{profile};
    $self->render_fillin($template, $profile_params);
    return;
}

# ユーザー情報検索(お仲間)
sub search {
    my $self = shift;

    # 今回は検索機能は実装しない
    my $profile_model = $self->model->sanpo->profile;
    $self->stash($profile_model->to_template_search);
    $self->stash($self->_template_common('sanpo/profile/search'));
    $self->render;
    return;
}

# ユーザー情報更新実行
sub update {
    my $self = shift;
    my $params = $self->req->params->to_hash;
    $self->render(text => 'update');
    return;
}

# ユーザー情報削除(退会)
sub remove {
    my $self = shift;
    $self->render(text => 'remove');
    return;
}

1;

__END__
