% GROUP 3 MCO3 IN CS-INSTY
% BONDOC, TAMAYO, TIPAN, YABUT

:- dynamic fullname/2.
:- dynamic info/3.
:- dynamic username/1.
:- dynamic newzealand/1.
:- dynamic australia/1.
:- dynamic philippines/1.
:- dynamic foreign/1.
:- dynamic returning/1.
:- dynamic accompany/2.
:- dynamic diplomat/1.
:- dynamic essential/1.
:- dynamic ofw/1.
:- dynamic others_work/1.
:- dynamic student/1.
:- dynamic travel/1.
:- dynamic approved/1.
:- dynamic documents_done/1.

start:-
    format('~nWould you like to travel to New Zealand? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  format('Are you a new user? ~n'),
        format('1 - Yes, 2 - No ~n'),
        read(Z),
        check_profile(Z)
    ;   format('Bye!')
    ).

%add new profile
check_profile(1):-
    write('First name: '),
    read(X),
    write('Last name: '),
    read(Y),
    format('Hi, ~s ~s! ~n', [X, Y]),
    assertz(fullname(X, Y)),
    write('Add a username: '),
    read(A),
    check_new(X, Y, A),
    format('Please type in your citizenship: ~n'),
    citizen_loop(A, 1),
    check_purpose(X, Y).

%user has existing profile
check_profile(2):-
    write('Please type your username:'),
    read(X),
    (   username(X), info(A, B, X),
        format('Welcome back ~s ~s! ~n', [A, B])
    ->  fly(X)
    ;   format('You are not in our database. ~n'),
        repeat_start
    ).

% used to get updated username when first input has the same username
% with another user
check_purpose(A, B):- info(A, B, C),
    fly(C).

%loop for adding new username and info
check_new(A, B, X):- not(username(X)), !,
    assertz(username(X)),
    assertz(info(A, B, X)).

check_new(A, B, X):- username(X), !,
    format('Username is taken. ~n'),
    write('Add a username: '),
    read(Y),
    check_new(A, B, Y).

%purpose for travel
purpose(X):-
    format('What is your reason for travel? ~n'),
    format('1 - citizen, 2 - returning resident, 3 - official business, ~n'),
    format('4 - tourist, 5 - emergency, 6 - others ~n'),
    read(A),
    reason(X, A).

%citizen
reason(X, 1):-
    format('~nChecking if you are a citizen of New Zealand... ~n'),
    (   newzealand(X)
    ->  format('You are a citizen of New Zealand. ~n'),
        assertz(approved(X))
    ;   format('You are NOT a citizen of New Zealand. ~n'),
        write('')
    ).

%returning resident
reason(X, 2):-
    format('You are a returning resident ~n'),
    format('Will you be traveling with others? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  format('Are they your family? ~n'),
        format('1 - Yes, 2 - No ~n'),
        read(Y),
       (   Y = 1
       ->  group(X, Y)
       ;   format('Only family members can travel in groups. ~n')
       )
    ;  group(X, 2)
    ).

%official business
reason(X, 3):-
    format('You are traveling for official bussines. ~n'),
    format('What businesses do you have in New Zealand? ~n'),
    format('1 - governmental purposes, 2 - vocational purposes ~n'),
    format('3 - educational purposes ~n'),
    read(Y),
    official_business(X, Y).

%tourist
reason(_, 4):-
    format('You are a tourist. ~n'),
    format('Sorry, but tourists cannot travel to New Zealand at the moment. ~n').

%emergency or critical purposes
reason(X, 5):-
    format('You are traveling for emergency or critical purposes. ~n'),
    format('~nSubmit a request to travel to New Zealand. ~n'),
    format('Is your request approved? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  assertz(approved(X))
    ;   format('The request should be approved first. ~n')
    ).

%others
reason(X, 6):-
    format('What other reasons do you have? ~n'),
    format('1 - humanitarian reasons, 2 - others ~n'),
    read(Z),
    other_reason(X, Z).

%others #1 - humaniratian reasons
other_reason(X, 1):-
    format('You are traveling for humanitarian reasons. ~n'),
    assertz(approved(X)).

%others #2 - others
other_reason(X, 2):-
    format('~nSubmit a request to travel to New Zealand. ~n'),
    format('Is your request approved? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  assertz(approved(X))
    ;   format('The request should be approved first. ~n')
    ).

%add to country of citizenship
same_citizen(1, X):-
    assertz(australia(X)).

same_citizen(2, X):-
    assertz(newzealand(X)).

same_citizen(3, X):-
    assertz(philippines(X)).

same_citizen(4, X):-
    assertz(foreign(X)).

%for asking citizenship. loop if citizen of more than 1 country
citizen_loop(_, 2):- write('').

citizen_loop(X, 1):-
    format('You are a citizen of what country? ~n'),
    format('1 - Australia, 2 - New Zealand, ~n'),
    format('3 - Philippines, 4 - others ~n'),
    read(C),
    same_citizen(C, X),
    format('Will you add more ? (If you a citizen of more than 1 country) ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(D),
    citizen_loop(X, D).

%documents for when user is a citizen of new zealand
nz_req_docs:-
    format('~nHere are the basic needed documents for your travel: ~n'),
    format('passport, negative RT-PCR test within 72 hours before travel, ~n'),
    format('PAL Passenger Information Form or PAL Partner Laboratory ~n'),
    format('e-CIF Form PH Bureau of Immigration Declaration Form. ~n~n').

%documents when user is not a citizen of new zealand
non_nz_req_docs:-
    format('~nHere are the basic needed documents for your travel: ~n'),
    format('passport, visa, negative RT-PCR test within 72 hours before travel. ~n'),
    format('You should also be fully vaccinated with your last dose ~n'),
    format('taken at least 14 days prior to the flight, ~n'),
    format('PAL Passenger Information Form or PAL Partner Laboratory ~n'),
    format('e-CIF Form PH Bureau of Immigration Declaration Form. ~n~n').

%official business #1 - government purposes
official_business(X, 1):-
    format('You are traveling for government purposes. ~n'),
    format('Are you a diplomat/consular official? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(Z),
    diplomat(X, Z),
    assertz(approved(X)).

%official business #2 - business or work purposes
official_business(X, 2):-
    format('You are traveling for business/work purposes. ~n'),
    format('Are you any of the following? ~n'),
    format('1 - essential worker, 2 - OFW, 3 - others ~n'),
    read(Z),
    job(X, Z).

%official business #3 - education purposes
official_business(X, 3):-
    format('You are traveling for education purposes. ~n'),
    (   student(X)
    ->  write('')
    ;   assertz(student(X))
    ),
    assertz(approved(X)).

%add x if diplomat or not
diplomat(X, Z):-
    (    Z = 1
    ->  ( diplomat(X)
        ->  write('')
        ;  assertz(diplomat(X)))
    ;   write('')
    ).

%add x to be an essential worker
job(X, 1):-
    (   essential(X)
    ->  write('')
    ;   assertz(essential(X))
    ),
    assertz(approved(X)).

%add OFW
job(X, 2):-
    format('You are an OFW. ~n'),
    format('~nHave you departed from New Zealand between 1 December 2019 ~n'),
    format('and 9 October 2020? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->   format('~nHave you held one of the following visas at the time you ~n'),
         format('left New Zealand? ~n'),
         format('Essential Skills Work Visa/Entrepreneur Work Visa/ ~n'),
         format('Work to Residence visa - Talent (Accredited Employer) Work Visa/ ~n'),
        format('Talent (Arts, Culture and Sports) Work Visa/Long Term Skill Shortage ~n'),
        format('List Work Visa/Skilled Migrant Category Job Search Visa/South ~n'),
        format('Island Contribution Work Visa/Global Impact Work Visa) ~n'),
        format('1 - Yes, 2 - No ~n'),
        read(B),
        (   B = 1
        ->  format('~nHave you witnessed statutory declaration, declaring you were ~n'),
            format('still employed in the same job when you left New Zealand? ~n'),
            format('1 - Yes, 2 - No ~n'),
            read(C),
            (   C = 1
            ->  format('~nHave you lived in New Zealand for more than 2 years before ~n'),
                format('leaving, or between 1 and 2 years? ~n'),
                format('If between 1 to 2 years you must at least satisfy one of the following: ~n'),
                format('had 1 or more dependent children with you in New Zealand for at least~n'),
                format('6 months of that 12-month period; ~n'),
                format('have parents or adult siblings currently in, and who are ordinarily resident ~n'),
                format('in, New Zealand; or submitted your application for your current resident ~n'),
                format('visa by 10 August 2020, or have held an Entrepreneur work visa at the time ~n'),
                format('of departing New Zealand, operated a business at the time of departing New ~n'),
                format('Zealand in accordance with the conditions of your visa, and have continued ~n'),
                format('to operate the same business since departing New Zealand. ~n'),
                format('1 - Yes, 2 - No ~n'),
                read(D),
                (   D = 1
                ->  (   ofw(X)
                    ->  write('')
                    ;   assertz(ofw(X)),
                        assertz(approved(X))
                    )
                ;   write('')
                )
            ;   write('')
            )
        ;   write('')
        )
    ;   write('')
    ).

%add x for others work
job(X, 3):-
    (   others_work(X)
    ->  write('')
    ;   assertz(others_work(X))
    ),
    assertz(approved(X)).

%will add the members of returning residences
group(X, 1):-
    format('Will this group be an existing group? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->   add_to_group(X)
    ;    (   returning(X)
         ->  write('')
         ; assertz(returning(X))
         ),
         format('~nAdd the details of your member. ~n~n'),
         find_returning(X),
         format('Will you add more people? ~n'),
         format('1 - Yes, 2 - No ~n'),
         read(B),
         add_group(X, B),
         display_group(X),
         assertz(approved(X))
    ).

%when returning resident user is traveling alone
group(X, 2):-
    (   returning(X)
    ->  write('')
    ; assertz(returning(X))
    ),
    assertz(approved(X)).

%add a user to an existing group for returning residences
add_to_group(X):-
    write('Please type the representatives username:'),
    read(A),
    (   returning(A)
    ->  (   accompany(A,X)
        ->  write('')
        ;   assertz(accompany(A, X))
        ),
        display_group(A),
        assertz(approved(X))
    ;   format('username not found. ~n')
    ).

%loop for adding members to group
add_group(X, 1):-
    find_returning(X),
    format('Will you add more people? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    add_group(X, A).

add_group(_, 2):-
    format('Done. ~n').

%will find or make the members account
find_returning(Y):-
    format('Do they have an existing account? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  search_returning(Y)
    ;   add_returning(Y)
    ).

%look for the members existing account
search_returning(Y):-
    write('Please type the members username:'),
    read(X),
    (   username(X), info(A, B, X),
        format('Welcome back ~s ~s! ~n', [A, B])
    ->  (   accompany(Y,X)
        ->  write('')
        ;   assertz(accompany(Y, X))
        ),
        (   returning(X)
        ->  write('')
        ;   assertz(returning(X))
        )
    ;   format('Member not in our database, make an account. ~n'),
        add_returning(Y)
    ).

%make an account for the member
add_returning(C):-
    write('First name: '),
    read(X),
    write('Last name: '),
    read(Y),
    format('Hi, ~s ~s! ~n', [X, Y]),
    assertz(fullname(X, Y)),
    write('Add a username: '),
    read(A),
    check_new(X, Y, A),
    format('Please type in your citizenship: ~n'),
    citizen_loop(A, 1),
    check_username(X, Y, C).

% used to get updated username when first input has the same username
% with another user
check_username(A, B, C):- info(A, B, Z),
    format('Please type in your citizenship: ~n'),
    citizen_loop(Z, 1),
    assertz(accompany(C, Z)),
    assertz(returning(Z)).

%display group members of returning residences
display_group(X):- returning(X), !,
    format('~n'),
    forall(accompany(X, Y),  writeln(accompany(X, Y))),
    format('~n').

%check what documents to print - if citizen or not
documents(X):- purpose(X),
    (   approved(X)
    ->  (   newzealand(X)
        ->  nz_req_docs
        ;   non_nz_req_docs
        ),
        (   diplomat(X)
        ->  format('Provide a diplomat visa. ~n')
        ;   format('Provide a Valid Managed Isolation Allocation System Voucher. ~n~n')
        ),
        additional_documents(X),
        assertz(documents_done(X)),
        retract(approved(X))
    ;   write('')
    ).

%additional documents for ofws
additional_documents(X):- ofw(X), !,
    format('You should be a holder of a normally resident work visa. ~n'),
    format('If visa has expired before 1 January 2021 you must have made ~n'),
    format('another visa application before 10 August 2020. ~n~n').

%additional documents for other business purposes
additional_documents(X):- others_work(X), !,
    (   not(newzealand(X))
    ->  format('>A New Zealand Electronic Travel Authority can be passed ~n
        in place of a visa ~n~n')
    ;   write('')
    ),
    format('~nIf it is considered to be other critical work, ~n'),
    format('Addtional requirements are: ~n'),
    format('Critical worker exemption from employer, ~n'),
    format('Critical Purpose Visitor Visa when approved. ~n~n').

%additional documents for student
additional_documents(X):- student(X), !,
    format('Nomination to study in New Zealand from education provider, ~n'),
    format('Nomination to study in New Zealand from New Zealand’s Ministry ~n'),
    format('of Education. ~n~n').

additional_documents(_):- !.

%print out things to do when landed to New Zealand
ready(X):- documents(X),
    (   documents_done(X)
    ->  format('Do you have all the requirements needed? ~n'),
        format('1 - Yes, 2 - No ~n'),
        read(A),
        (   A = 2
        ->  format('Come back when everything is ready. ~n'),
            find_retract(X)
        ;   assertz(travel(X))
        ),
        retract(documents_done(X))
    ;   write('')
    ).

%retract purpose of user
find_retract(X):-
    (   diplomat(X)
    ->  retract(diplomat(X))
    ;   (   ofw(X)
        ->  retract(ofw(X))
        ;   (   others_work(X)
            ->  retract(others_work(X))
            ;   (   student(X)
                ->  retract(student(X))
                ;   (   returning(X)
                    ->  retract(returning(X))
                     /* (   accompany(_, X)
                        ->  retract(accompany(_,X))
                        ;    (   accompany(X, _)
                             ->  retractall(accompany(X,_))
                             ;   write('')
                             )
                        )  */
                    ;   (   essential(X)
                        ->  retract(essential(X))
                        ;   write('')
                        )
                    )
                )
            )
        )
    ).

% if user can travel to New Zealand, will print the procedures upon
% arriving to the country
fly(X):- ready(X), !,
    (    travel(X)
    ->   format('Lets Go! ~n'),
         format('~nHere are the procedures to follow upon arrival in the country: ~n'),
         format('Managed isolation and quarantine minimum of 7 days from the date ~n'),
         format('and time of arrival in New Zealand, ~n'),
         format('Covid-19 testing while in managed isolation facility: ~n'),
         format('>happens on or around day 0-1 (arrival), day 3, ~n'),
         format('and day 5-6 (prior departure from MIQ) ~n'),
         format('>negative Rapid Antigen Test if day 5-6 result was not received before day 7, ~n'),
         format('and they are traveling outside Auckland'),
         retract(travel(X)),
         find_retract(X)
    ;   format('You are not allowed to travel. ~n')),
    repeat_start.

%back to start
repeat_start:-
    format('~n~n~nBack to menu? ~n'),
    format('1 - Yes, 2 - No ~n'),
    read(A),
    (   A = 1
    ->  start
    ;   format('~nThanks for using us! ~n')
    ).
