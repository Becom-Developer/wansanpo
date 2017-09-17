package Wansanpo::Controller::Sanpo::Pet;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# ペット情報詳細
sub show {
    my $self = shift;
    $self->render( text => 'show' );
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
