# USI Core

Uczelniane Systemy Informatyczne &ndash; podstawa dla kolejnych modułów (komponentów) systemu. Obecnie dostępne komponenty:

1. [Diament][3] &ndash; moduł wspomagający proces zapisów na prace dyplomowe. 
2. [Grafit][4] &ndash; moduł wspomagający proces zapisów na przedmioty obieralne. 



Strona projektu: [http://mine.opensoftware.pl][1]

# Demo

Wersja demonstracyjna systemu dostępna jest [tutaj][2].

Przykładowi użytkownicy:

* osoba z uprawnieniami wydziałowego administratora:
Login: `szef@at.edu`

* osoba z uprawnieniami kierownika katedry:
Login: `kierownik@at.edu`

* osoba z uprawnieniami promotora:
Login: `torpeda@at.edu`

* osoba z uprawnieniami studenta:
Login: `babel@at.edu `

Hasło do wszystkich kont: `123qweasdzxc`.

Znaczenie poszczególnych uprawnień zależy od dodanych rozszerzeń ([Diament][3] i/lub [Grafit][4]). Ich szerszy opis jest dostępny na stronie danego rozszerzenia.

# Wymagania:

* GNU/Linux - praktycznie dowolna dystrybucja, zalecana GNU/Debian
* Ruby >= 2.0
* Ruby on Rails = 4.0.4
* PostgreSQL >= 9.0
* Redis >= 2.8.4
* Memcached >= 1.4.14

# Instalacja

1. Sklonowanie repozytoriów USI core + `graphite` i/lub `diamond`, następnie wejście do katalogu ze źródłami USI core (domyślnie `core`).
2. Utworzenie pliku Gemfile projektu: `cp Gemfile.sample Gemfile`, następnie edycja Gemfile, odkomentowanie gemów `Diamond` i `Graphite`.
3. Wykonanie komendy `bundle install`.
4. Przygotowanie konfiguracji do łączenia z bazą danych PostgreSQL: `cp config/database.yml.sample config/database.yml`. Nastepnie edycja `config/database.yml` i uzupełnienie parametrów połączenia z bazą danych.
5. Przygotowanie konfiguracji bazy danych Redis: `cp config/resque.yml.sample config/resque.yml`. Nastepnie edycja `config/resque.yml` i uzupełnienie parametrów połączenia z bazą danych.
6. Wykonanie komendy `rake db:create db:migrate db:seed:original db:seed:demo`.
7. Wykonanie komendy `cp config/initializers/secret_token.rb.template config/initializers/secret_token.rb`, a następnie `rake secret`. Wynikiem działania będzie wygenerowany `secret_token`, który należy przekopiować do pliku `config/initializers/secret_token.rb`.
8. Uruchomienie instancji serwera: `rails s`.

Jeżeli potrzebujesz wsparcia przy wdrożeniu systemu, zapraszamy do kontaktu z nami.

# Licencja

AGPL

Patrz plik LICENSE

# Kontakt

biuro@opensoftware.pl

[1]: http://mine.opensoftware.pl
[2]: http://usi-demo.opensoftware.pl/
[3]: https://github.com/Opensoftware/USI-Diamond
[4]: https://github.com/Opensoftware/USI-Graphite
