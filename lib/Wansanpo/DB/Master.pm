package Wansanpo::DB::Master;
use Mojo::Base 'Wansanpo::DB::Base';
use Mojo::Util qw{dumper};

has [qw{master_hash master_constant_hash}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::DB::Master!!';
}

# authority 権限
sub authority {
    my $self = shift;
    my $hash = +{
        0 => '権限なし',
        1 => 'root',
        2 => 'sudo',
        3 => 'admin',
        4 => 'general',
        5 => 'guest',
        6 => 'customer',
    };

    my $constant = +{
        NOT_AUTHORITY => 0,
        ROOT          => 1,
        SUDO          => 2,
        ADMIN         => 3,
        GENERAL       => 4,
        GUEST         => 5,
        CUSTOMER      => 6,
    };

    $self->master_hash($hash);
    $self->master_constant_hash($constant);
    return $self;
}

# deleted 削除フラグ
sub deleted {
    my $self = shift;
    my $hash = +{
        0 => '削除していない',
        1 => '削除済み',
    };

    my $constant = +{
        NOT_DELETED => 0,
        DELETED     => 1,
    };

    $self->master_hash($hash);
    $self->master_constant_hash($constant);
    return $self;
}

# gender 性別
sub gender {
    my $self = shift;
    my $hash = +{
        1 => '男性',
        2 => '女性',
    };

    my $constant = +{
        MALE   => 1,
        FEMALE => 2,
    };
    $self->master_hash($hash);
    $self->master_constant_hash($constant);
    return $self;
}

# 単語から id を求める
sub word_id {
    my $self = shift;
    my $word = shift;
    my $word_id;
    while ( my ( $key, $val ) = each %{ $self->master_hash } ) {
        $word_id = $key;
        return $word_id if $val eq $word;
    }

    # 単語が見つからない時
    die 'error master methode word_id: ';
}

# word_id から単語を求める
sub word {
    my $self    = shift;
    my $word_id = shift;
    my $word    = $self->master_hash->{$word_id};
    die 'error master methode word: ' if !defined $word;
    return $word;
}

# 定数を求める
sub constant {
    my $self     = shift;
    my $label    = shift;
    my $constant = $self->master_constant_hash->{$label};
    die 'error master methode constant: ' if !defined $constant;
    return $constant;
}

# 定数のラベルを求める
sub label {
    my $self     = shift;
    my $constant = shift;
    my $label;
    while ( my ( $key, $val ) = each %{ $self->master_constant_hash } ) {
        $label = $key;
        return $label if $val eq $constant;
    }

    # ラベルが見つからない時
    die 'error master methode constant: ';
}

sub to_hash {
    my $self = shift;
    my $hash = $self->master_hash;
    my @keys = keys %{$hash};
    die 'error master methode to_hash: ' if !scalar @keys;
    return $hash;
}

sub to_ids {
    my $self = shift;
    my $hash = $self->master_hash;
    my @keys = keys %{$hash};
    die 'error master methode to_ids: ' if !scalar @keys;
    my @sort_keys = sort { $a <=> $b } @keys;
    return \@sort_keys;
}

sub sort_to_hash {
    my $self = shift;
    my $hash = $self->master_hash;
    my @keys = keys %{$hash};
    die 'error master methode sort_to_hash: ' if !scalar @keys;
    my @sort_keys = sort { $a <=> $b } @keys;
    my $sort_hash;
    for my $key (@sort_keys) {
        push @{$sort_hash}, +{ id => $key, name => $hash->{$key} };
    }
    return $sort_hash;
}

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::DB::Master - マスターデータオブジェクト

=head1 SYNOPSIS

    # コントローラーにて
    my $master = $self->model->db->master;

    # モデルにて
    my $master = $self->db->master;

    # 単語から id を求める
    my $word = 'guest';

    # 5
    my $authority = $master->authority->word_id($word);

    # word_id から単語を求める
    my $word_id = 5;

    # 'guest'
    my $authority = $master->authority->word($word_id);

    # 定数を求める
    # my $label = 'GUEST';

    # 5
    # my $authority = $master->authority->constant($label);

    # 定数のラベルを求める
    # my $constant = 5;

    # 'GUEST'
    # my $authority = $master->authority->label($constant);


    # その他データの集合体を求める

    # [ 0 ,1, ... ]
    my $authority = $master->authority->to_ids;

    # +{  0 => '権限なし',
    #     1 => 'root',
    #     ...
    # };
    my $authority = $master->authority->to_hash;

    # [
    #     +{ id => 0, name => '権限なし', },
    #     +{ id => 1, name => 'root', },
    #     ...
    # ]
    my $authority = $master->authority->sort_to_hash;

=cut
