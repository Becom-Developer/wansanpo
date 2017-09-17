package Wansanpo::Controller::Sanpo::Pet;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# ペット情報詳細
sub show {
    my $self = shift;
    my $params = +{ id => $self->stash->{id}, };

    my $pet_model = $self->model->sanpo->pet->req_params($params);
    $self->stash( $pet_model->to_template_show );

    # ログイン者以外の場合は編集ボタンを表示しない
    my $is_login_user;
    if ( $pet_model->is_login_user( $self->login_user->id ) ) {
        $is_login_user = 1;
    }
    $self->stash(
        is_login_user => $is_login_user,
        class_active  => +{
            wansanpo => 'active',
            pet      => 'active',
        },
        template => 'sanpo/pet/show',
        format   => 'html',
        handler  => 'ep',
    );
    $self->render;
    return;
}

# ペット情報編集画面
sub edit {
    my $self = shift;
    $self->render( text => 'edit' );
    return;
}

# ペット情報新規登録画面
sub create {
    my $self = shift;
    $self->render( text => 'create' );
    return;
}

# ペット情報新規登録実行
sub store {
    my $self = shift;
    $self->render( text => 'store' );
    return;
}

# ペット情報検索
sub search {
    my $self = shift;
    $self->render( text => 'search' );
    return;
}

# ペット情報更新実行
sub update {
    my $self = shift;
    $self->render( text => 'update' );
    return;
}

# ペット情報削除
sub remove {
    my $self = shift;
    $self->render( text => 'remove' );
    return;
}

1;

__END__
