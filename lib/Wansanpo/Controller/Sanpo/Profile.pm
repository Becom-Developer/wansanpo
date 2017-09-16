package Wansanpo::Controller::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Controller::Sanpo';

# ユーザー情報詳細
sub show {
    my $self = shift;
    my $params = +{ id => $self->stash->{id}, };

    my $profile_model = $self->model->sanpo->profile->req_params($params);
    $self->stash($profile_model->to_template_show);
    $self->stash(
        class_active => +{
            wansanpo => 'active',
            profile  => 'active',
        },
        template => 'sanpo/profile/show',
        format   => 'html',
        handler  => 'ep',
    );
    $self->render;
    return;
}

# ユーザー情報編集画面
sub edit {
    my $self = shift;
    $self->render( text => 'edit' );
    return;
}

# ユーザー情報検索(お仲間)
sub search {
    my $self = shift;
    $self->render( text => 'search' );
    return;
}

# ユーザー情報更新実行
sub update {
    my $self = shift;
    $self->render( text => 'update' );
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
