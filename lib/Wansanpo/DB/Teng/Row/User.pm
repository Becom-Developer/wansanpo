package Wansanpo::DB::Teng::Row::User;
use Mojo::Base 'Teng::Row';
use Mojo::Collection;

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::User - Teng Row オブジェクト拡張

=cut

sub fetch_profile {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    return $self->handle->single( 'profile', $cond );
}

sub search_pet {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    my @rows = $self->handle->search( 'pet', $cond );
    return \@rows;
}

# 始めてのログイン
sub is_first_login {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    my $row  = $self->handle->single( 'profile', $cond );
    return 1 if !defined $row->name || $row->name eq '';
    return;
}

# メッセージ履歴のあるユーザー情報を取得
sub search_msg_friend_user {
    my $self = shift;

    my $msg_friend_ids = [];

    # 自分が送信者のメッセージから宛先のユーザー
    my $cond = +{ from_user_id => $self->id, deleted => 0, };
    my @message_rows = $self->handle->search( 'message', $cond );

    for my $msg (@message_rows) {
        push @{$msg_friend_ids}, $msg->to_user_id;
    }

    # 自分が宛先のメッセージから送信者のユーザー
    $cond = +{ to_user_id => $self->id, deleted => 0, };
    @message_rows = $self->handle->search( 'message', $cond );

    for my $msg (@message_rows) {
        push @{$msg_friend_ids}, $msg->from_user_id;
    }

    my $collection = Mojo::Collection->new( @{$msg_friend_ids} );
    my $ids        = $collection->uniq->to_array;

    # ユーザー情報取得
    $cond = +{ id => $ids, deleted => 0, };
    my @user_rows = $self->handle->search( 'user', $cond );
    return \@user_rows;
}

# メッセージ履歴を取得
sub search_msg_history {
    my $self      = shift;
    my $friend_id = shift;

    # 自分が送信した履歴 自分に送信された履歴
    my $cond = +{
        from_user_id => [ +{ '=' => $friend_id }, +{ '=' => $self->id } ],
        to_user_id   => [ +{ '=' => $friend_id }, +{ '=' => $self->id } ],
        deleted      => 0,
    };

    my $attr = +{ order_by => 'created_ts DESC' };
    my @message_rows = $self->handle->search( 'message', $cond, $attr );
    return \@message_rows;
}

1;

__END__

