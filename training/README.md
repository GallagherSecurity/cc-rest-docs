# Work in progress:  Command Centre REST API training material

This document will be a markdown port of a document used internally at Gallagher Group to train
developers in the use of Command Centre's REST API.  This version is not yet suitable for
publication, but if you are using the REST API and like the sound of 60-odd more pages of reading
material, please contact Gallagher through your channel partner and talk to our Technical Support
Engineers about your project.

## Disclaimer

This document gives certain information about products and/or services provided by Gallagher Group
Limited or its related companies (referred to as "Gallagher Group").

The information is indicative only and is subject to change without notice meaning it may be out of
date at any given time.  Although every commercially reasonable effort has been taken to ensure the
quality and accuracy of the information, Gallagher Group makes no representation as to its accuracy
or completeness and it should not be relied on as such.  To the extent permitted by law, all express
or implied, or other representations or warranties in relation to the information are expressly
excluded.

Neither Gallagher Group nor any of its directors, employees or other representatives shall be
responsible for any loss that you may incur, either directly or indirectly, arising from any use or
decisions based on the information provided.

Except where stated otherwise, the information is subject to copyright owned by Gallagher Group and
you may not sell it without permission.  Gallagher Group is the owner of all trademarks reproduced
in this information.  All trademarks which are not the property of Gallagher Group, are
acknowledged.

Copyright © Gallagher Group Ltd 2021.  All rights reserved.

Gallagher Group Limited  
PO Box 3026  
Hamilton  
New Zealand  
+64 (7) 838 9800   
E-Mail: sales.nz@security.gallagher.com  
Website: www.gallagher.com  

# Table of contents

1. [References](#references)
1. [Setup](#setup)
1. [Useful background](#useful-background)

# Introduction

DRAFT DO NOT DISTRIBUTE.

This document is an introduction to using the REST API in Command Centre, aimed at those involved in
the development of software that will integrate Command Centre into other solutions.  It was written
to accompany an informal education session with a Gallagher trainer.

It covers features first released in 7.80 and expanded in 7.90.

It uses the following styles for guided examples:

`Fixed-width fonts` indicate filenames, parts of URLs, and text that benefits from vertical
alignment.

    Indented fixed-width blocks are client requests that you can copy out for your own work,
    and server responses pretty-printed a little to make them readable.

<pre>Indented fixed-width blocks are client requests that you can copy out for your own work (values
you should change are in <i>italics</i>) and server responses, pretty-printed a little to make them
readable.</pre>

TODO ^^^

> Special notes use Markdown's quotes, like this.

## Exclusions

This document does not cover special handling of PIV cards.  It shows how to create a generic card
and leaves the variations for PIV and PIV-I to the developer documentation.

Nor does it cover some of the features added after v7.90:  access zones, alarm zones, fence zones,
doors, outputs, inputs, PDF definitions, macros, changing cardholder zones, operators, visitors,
schedules, and subscribing to cardholder updates.

# References

This document refers to API documentation, online help, and sample code.  All are on the Command
Centre ISO (or DVD, if you have physical media).

## Developer API documentation
https://gallaghersecurity.github.io/ holds the reference API documentation.  That is the primary
reference for the REST API, so it aims to be complete, and you should have it on hand whenever
developing against Command Centre.  However the amount of detail can be daunting and it is not very
introductory, which is why this document exists.

We are always improving the content so it is best read online, but if you need an offline copy you
can either download a ZIP from https://github.com/GallagherSecurity/cc-rest-docs, or take a copy
from Utilities/REST API/REST Documentation*/ in the ISO.  Beware, however, that the copy on the DVD
lags the online version by weeks or months.

It comprises five HTML files:
* index.html gives links to the other four;
* cardholders.html describes the cardholder API calls and supporting concepts, such as card types,
  access groups, PDFs, roles, and competencies.  These functions were new to 7.90.  8.30 added a
  cardholder change-tracking API;
* piv.html covers the additional fields you supply and see on PIV and PIV-I cards;
* events.html covers the alarms and events calls.  This is all that was available in 7.80.  8.10
  added the ability to create your own events;
* rest.html covers Command Centre items that are not cardholders, alarms, or events:  alarm zones,
  access zones, fence zones, outputs, doors, and macros arrived in 8.00, and inputs in 8.10.  8.30
  added a way to mass-monitor items.

If running on Windows, something in the mix of Internet Explorer, Javascript, and file: URLs on
network shares prevents the HTML rendering properly so if those files look goofy to you, try a
different browser or copy the folder to your local drive.  Or read it online.

## Online help and PDF documents

The Configuration Client’s Help menu opens a CHM file that you can also find in the ISO at
Setup\Program Files\Gallagher\Command Centre\Bin\Resources\en.  There is a PDF version, split into
three volumes, on the ISO in the Documentation folder.

The Command Centre hardening guide, also on the ISO, is required reading for security-conscious
sites.  While you may not be able to follow its leading advice regarding the REST API (‘leave it
turned off’) there is plenty more in there to be aware of.

If you are interested in the security of the REST API, look in TODO_LINK for how the server
authenticates and authorises requests in general, and TODO_LINK for how it authenticates clients
using certificates.

## Sample code
See Utilities/REST API/REST API Sample Code.zip in the Command Centre ISO.  There is a WPF client in
there and a console application, in a C# Visual Studio solution.

# Setup

If you wish to try the REST API for yourself, you will require:

* Command Centre 7.90 or later with a RESTCardholders licence, a RESTEvents licence if you are to
  examine events, RESTStatus if you are to look at site items, RESTOverrides if you want to override
  them, and RESTCreateEvents if you wish to create events.  This document does not cover the last
  three.
* A host capable of reaching port 8904 on Command Centre via HTTPS, or desktop access to the CC
  server itself.
* The sample REST client application from the Command Centre installation media (8.10 onward).
* (Optional) the Postman installer, or access to it on the internet.
* (Optional) Chrome and access to the internet for two extensions.
* The API developer documentation, online and on the Command Centre installation media.

# Useful background

This section contains material you should have aboard before reading on.  Skip it if you are
familiar with CC.

## Cardholders
Cardholders are user accounts.  Depending on what you give a cardholder account it can suit
different purposes:

* people with cards and access needs, but no administrative responsibilities.  The REST API allows
  management of these kinds of cardholders;
* administrative people with all that plus the rights to configure the system and manage its users.
  8.50 added features for managing these kinds of cardholders;
* system accounts with no person associated and no physical access, but administrative access to the
  system.  You are about to create one of these.

## Operators and operator groups
Operators are cardholders with benefits.  They become operators through membership of one or more
operator groups.  An operator group bestows privileges on its members, including the ability to log
in to the Command Centre thick clients or run REST queries.

Operator groups have no effect on access control, so they do not appear in this document again
except in TODO_LINK which puts a cardholder in an operator group while setting up a REST client.
Operator groups came to the API in 8.50.

## Access groups
Cardholders can be members of any number of access groups.  An access group can be a member of one
other—its parent.  Command Centre considers a member of a group to be a member of all the groups up
its parenting line, as you would expect.

A cardholder must be a member of an access group before he or she can open a door, so every
cardholder that represents a person should have group memberships.  (Footnote:  there are exceptions
of course.  Some visitors, for example, do not need to open doors, but they exist in CC so that it
can record their location as they move around the site with their host.)

A cardholder can have many memberships of the same group.  This is useful because each has its own
start and end times.  Past memberships fade away.

Access groups are not operator groups.  When this document refers to a group it means an access
group.

A cardholder must be a member of an access group before he or she can have personal data, next.

## Personal data fields (PDFs)

A Personal Data Field is an item that adds a custom value to a cardholder.  Each PDF has a type
(text, image, numeric, date, telephone number, email address…) and optional constraints on the
values that it can hold.  For example, text, email, and telephone number types can have a regular
expression attached which a new value must match before Command Centre will accept it.  A date can
have a maximum and a minimum.  Text PDFs can have a list of valid values, like an enumeration.

There is more configuration:  image PDFs have a type and size, to which Command Centre will
transcode incoming images.  Mobile numbers and email addresses have a flag indicating whether they
are suitable to receive SMS and email notifications.  All PDFs have their own access level (hidden,
read-only, or full access) that applies to operators in operator groups that do not expressly
override it.

Importantly, PDFs are attached to access groups.  A cardholder can have a value for a PDF only if he
or she is a member of one of the PDF’s access groups (Footnote:  direct or inherited.  Unless
otherwise noted, all Command Centre’s access group membership tests treat inherited members just
like direct members).

The REST API allows you to manage a cardholder’s group memberships (so that he or she has the PDF)
as well as see and set PDF values.  It does not let you see or change the configuration of the PDF
item.

## Divisions
Every item in the API is in a division (footnote:  except day categories.  They are divisionless).
Divisions are arranged in a tree:  each has exactly one parent, aside from the root division, which
has none.  An operator group specifies the roots of the division trees to which it grants
privileges.

Therefore an operator with privileges on the root division has those privileges on all that server’s objects.

Complication:  multi-server clusters have one root node (and therefore one tree of divisions) per server.

If you find that an operator cannot see or modify an item, the questions you should ask are:

### Which division is the item in?
The Command Centre client shows a cardholder’s division in the ‘Cardholder Details’ pane of the
cardholder viewer.  The Configuration Client shows the division of any item in the ‘General’ tab of
its property page.  The REST API shows it in the `division` field.

> The operator’s division and his or her operator groups’ divisions in the ‘General’ tabs are
> irrelevant.  The operator group grants privileges on the divisions in the ‘Divisions’ tab.

## Roles
A role defines a relationship between two cardholders.  One cardholder can perform a role for many
others but can have it performed for them by only one other.  It makes more sense when you use the
example ‘supervisor’:  a person has a supervisor and is a supervisor for many others.  When you use
REST to look up or update a cardholder, you will work on the ‘has a’ relationships, not the ‘is a’
relationships.  In other words you can change the cardholder’s supervisor but not who the cardholder
supervises.

## Competencies
Basically, competencies are another condition that a cardholder must meet to pass an access check.

The REST API lets you manage the links between cardholders and competencies:  create them, delete
them, enable/disable them, and set their expiry dates.

A competency can be disabled, expired, both, or neither.  Actions at a door can depend on whether a
competency is disabled, expired, soon to expire, or all good.

Whether it is disabled is a flag, plain and simple.  Whether it is expired is derived from an expiry
date (actually a timestamp):  if it is in the past, Command Centre considers the competency expired.

A competency can also have an enable date.  If that date (timestamp) passes while the competency is
disabled, Command Centre will enable it.

If the competency is not disabled, the 'expires' time is important.  If it is in the past, the
cardholder’s competency is expired.  If it is not set, or it is in the future, the cardholder
benefits from the competency.

| Enabled flag | Enablement date | Expiry date | Status
| ------------ | -------------- | --------| ----- |
| Set | - | Far future | Active |
| Set | - | Near future | Active (with a warning at the door) |
| Set | - | Past | Inactive (expired) |
| Unset | Future | - | Inactive (pending) |
| Unset | Past | - | Inactive (disabled) |
| Unset | null | - | Inactive (disabled) |

## Card types

A card type carries rules for the data that a card carries, PINs, how to treat cards around their expiry time, and default values for new cards of that type.  We often use the word credential, because not all card types involve a physical card:  there are also biometric and mobile card types.

The REST API provides read access to card types so that you can manage cardholders’ credentials.

PIV cards have their own developer document, separate from the rest of the cardholder API.

## All the above are items

The API lets you search for items and examine them, but—other than cardholders and schedules—it does
not let create, alter, or delete them.  The purpose of the cardholder API is to let you associate
items with cardholders and manage those associations.

## Events and alarms in Command Centre
Events record occurrences in the system.  They are not items.  They have an ID, a source item, an
occurrence time, and links to other related items.  Events are immutable:  the events you read from
the REST API will not change.

Alarms are events with extra fields, and some of them are mutable:  there is a free-text notes field
that you can edit in the thick clients, a history, and Booleans recording whether the alarm is
acknowledged, processed, and active.

The alarms interface only shows unprocessed alarms in its search results.  Once an operator
processes an alarm, it disappears from alarm searches.  However, the alarm still exists in the
database and an alarm is also an event, so the events interface will return it whether somebody
processed it or not.

## Operator privileges
Or just ‘privileges’ since there is no other kind.

An operator has privileges over a division and all its subdivisions.  When we refer to an operator
having a privilege on a cardholder, for example, we mean that the operator has that privilege on the
cardholder’s division, or one of its ancestor divisions.

In the interests of security, you should give your REST operators the minimum privileges they
require to achieve their task.

A table on TODO_LINK gives some examples of privileges you will need for various tasks.

## HTTP requests:  GET, POST, PATCH, DELETE, headers, bodies.
An HTTP request has four parts:  a verb, an address, a handful of headers, and a body.

###	Verbs
The verbs we will use are GET, POST, PATCH, and DELETE (in upper case by convention).  GET and
DELETE are self-explanatory but the other two are often confused.  In this API we use POST to create
something new such as a cardholder, and PATCH to modify something like the end-date on a group
membership.

### Addresses (URLs)
The address is the URL that everyone is accustomed to.  In a REST API the address identifies the
object you wish to GET, PATCH, or DELETE.  When POSTing, the address identifies the type of thing
you wish to create.

### Headers
Headers are a list of key/value pairs.  We use one called Authorization (spelled with a Z) to carry
client authentication, and one called Content-Type to be clear that we use JSON.

### Bodies
The body of a GET or DELETE request is empty.  A POST can also be empty, but they usually carry some
instructions for what you want created.  A PATCH always needs a body that contains instructions for
how to modify the item identified by the address.

If the body is not empty, it must contain JSON (below).

The sample application “CCFT REST Client” opens a console window that shows you the verb and address
of the HTTP queries it is making.  It can also show you the bodies of its queries and the server’s
responses.

## HTTP responses:  codes, and more headers and bodies.
An HTTP response has three parts:  a numeric response code, more headers, and a body.

### Response codes
Any response in the 200-299 range means success.  GETs return a 200 along with their results.
DELETEs and MODIFYs return 204 (“no content”), which just means they succeeded and having nothing
more to say.  Creating a cardholder or event returns 201 (“created”).

A response in the 400-499 range generally means there was something wrong with the request.  One
exception is 409:  it could mean that your timing was bad and trying again later may succeed.  Along
with 404, 409 could also mean you have attempted to do something beyond your privilege.  The body of
the response that comes back from the server will tell you the problem.

500-level responses mean the server has met with trouble.  Waiting for updates on events or items is
an exception:  if you ask Command Centre for updates and none arrives before the timeout, it will
return 503.  That is actually a kind of success:  it means nothing changed while you were waiting,
so a future version of Command Centre may return a 200-level code in this case.

### Headers
The only time Command Centre returns a header of interest is after it processes a POST to create a
cardholder or event.  It sets a header called Location containing the URL of your new object.

### Bodies
The body of a GET response contains everything you asked for, in JSON.  The body that comes back
from other verbs is empty unless there was a problem.

Chrome will show you the body.  Press F12 and resend the request to make Chrome show you the
response code and the headers as well (along with lots of other useful information).  Postman (a web
client we will get to later) always shows you everything.

## JSON
…though familiarity with XML or any programming language should be enough.  With line breaks and
indentation and a bit of colour, JSON is quite readable.

JSON can contain flat fields, objects (structures), and arrays.

    {
        "a text field": "string",
        "a numeric field": 1234,
        "a Boolean field": false,
        "an object": {
            "sub-field1": "foo",
            "sub-field2": "bar"
        },
        "an array": [
            "the array's first object": {
                "sub-field1": "jingle",
                "sub-field2": "bells"
            },
            "another object": {
                "sub-field1": "foo",
                "sub-field2": "bar"
            }
        ]
    }

In that example, the array called an array shows an array containing two more objects, each of which
contains two fields of its own.

## 3.15	Authentication and encryption certificates
Before an API call can succeed the client needs to decide to trust the server and then the server
needs to decide to trust the client.  They do that using _certificates_.

First a little background.  Very simply put, the current algorithms for secure communication require
a pair of _keys_.  Keys are nothing more than huge numbers.  The two in the pair are different, but
mathematically related so that when you encrypt some data using one key, nobody can decrypt it if
they do not have the other key.  The encryption key is public because there is no harm in encrypting
data.  People toss encryption keys around like business cards.  Its mate, the decryption key, is
very, very private.  They are not called the encryption and decryption keys because they do more
than just that, so the business card one is called the _public key_ and the other is the _private
key_.

A _certificate_ contains a public key plus metadata:  what the key is meant for, for how long, and
some proof that it is authentic, if there is any.  That proof of authenticity takes the form of a
signature from an authority that the internet has agreed to trust, such as Symantec or Verizon.
Client certificates, and some server certificates, do not have a signature.  Or they do, but it is
their own signature, which does not really count because nobody trusts it.  Such certificates are
called _self-signed_.  Web browsers cook up their own self-signed certificates all the time.  Web
server certificates, on the other hand, change infrequently (months or years).

If an HTTPS client and server connect and establish an encrypted channel of communication without
checking certificates nobody will be able to listen in, but they should not trust each other.  The
other end could be fibbing.  So they conduct a negotiation to establish each other’s identity (i.e.,
they _authenticate_).

Usually a web client requires proof of authenticity from the server, since you want to be sure that
it really is your bank’s web site you are looking at and not a fake.  If the server does not provide
that, the client shows a warning.  You will have to work around it in TODO_LINK6.3 and TODO_LINK7.3.
If you want to install your own server key, the topic ‘Changing the Web Services’ in the
Configuration Client’s online help shows you how.

Sometimes the server also requires a proof of identity from the client.  This does not happen when
using most web sites because (continuing the bank example) your bank has not pinned your client
certificate:  it does not care where you are coming from.  But APIs should operate more securely
than web sites so our recommendation is to turn it on.  Section TODO_LINK18 talks about client
certificates.

> It is important to know the difference between the two certificate checks, and to know that they
> are completely independent.  If the client does not trust the server, Command Centre will not
> receive a connection and will not raise any alarms.  The problem is on the client and there is
> nothing you can do to Command Centre to help.  But if the server certificate is acceptable to the
> client, the server has a chance to check the client certificate.  If the server does not like the
> client certificate, Command Centre will raise an ‘invalid client certificate’ alarm.

## 3.16	Items versus a cardholder’s link to them
Talking about a PDF or a competency can be confusing, because there is a PDF item and a competency
item, and cardholders can have PDFs and competencies, but the item and the cardholder’s link to the
item are different things.

The items (on the left in the table below) and the connection to a cardholder (on the right) both
appear in the REST API, but the API only lets you change the connections.  Until 8.50 added schedule
management, a cardholder was the only kind of item you could create or modify.  So let us make some
definitions:

| Item | A cardholder’s possession of that item|
| --- | --- |
|Access group | Group membership|
|Competency	| Cardholder competency |
|Role | Relationship (the role is the nature of the relationship between two cardholders) |
|Locker | Locker assignment |
|PDF | Cardholder PDF, or PDF value |

There is a question of scale.  You may have ten access groups, but thousands of group memberships.
You may have only one role in the system, but one relationship per cardholder.

For that reason, the API calls that list items do not list their connections to cardholders.  The
result sets would be too large.  Instead, you see those connections from the cardholder side:  when
you GET a cardholder’s details, you will see all the connections that cardholder has to PDFs,
competencies, groups, cards, lockers, and roles.

Access groups and operator groups will show you their cardholder members, but only if you ask.
