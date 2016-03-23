requires 'perl', '5.008_001';
requires 'Encode', '2.70';
requires 'Term::ReadLine', '1.14';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

