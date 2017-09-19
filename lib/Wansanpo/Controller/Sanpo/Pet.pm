package Wansanpo::Controller::Sanpo::Pet;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# テンプレ用共通スタッシュ
sub _template_common {
    my $self     = shift;
    my $template = shift;

    return +{
        class_active => +{
            wansanpo => 'active',
            pet      => 'active',
        },
        template => $template,
        format   => 'html',
        handler  => 'ep',
    };
}

# ペット情報詳細
sub show {
    my $self = shift;

    my $params = +{id => $self->stash->{id},};
    my $pet_model = $self->model->sanpo->pet->req_params($params);

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user = $pet_model->is_login_user($self->login_user->id);
    $self->stash($pet_model->to_template_show);
    $self->stash(is_login_user => $is_login_user);
    $self->stash($self->_template_common('sanpo/pet/show'));
    $self->render;
    return;
}

# ペット情報編集画面
sub edit {
    my $self = shift;
    $self->render(text => 'edit');
    return;
}

# ペット情報新規登録画面
sub create {
    my $self = shift;
    $self->render(text => 'create');
    return;
}

# ペット情報新規登録実行
sub store {
    my $self = shift;
    $self->render(text => 'store');
    return;
}

# ペット情報検索
sub search {
    my $self = shift;

    # 今回は検索機能は実装しない
    my $pet_model = $self->model->sanpo->pet;
    $self->stash($pet_model->to_template_search);
    $self->stash($self->_template_common('sanpo/pet/search'));
    $self->render;
    return;
}

# ペット情報更新実行
sub update {
    my $self = shift;
    $self->render(text => 'update');
    return;
}

# ペット情報削除
sub remove {
    my $self = shift;
    $self->render(text => 'remove');
    return;
}

1;

__END__
