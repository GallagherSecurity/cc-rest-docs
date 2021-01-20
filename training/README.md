<!--

TODOs:

Change all ‘ and its partner to '


-->

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

1. [References](#references):  API reference, user manuals, and sample code.
1. [Training Setup](#training-setup):  what you will need to try the API.
1. [Useful background](#useful-background):  an introduction to Command Centre for people who are
   new to physical access control systems or REST.  

   [Cardholders](#cardholders), [Operators and operator groups](#operators-and-operator-groups),
   [Access groups](#access-groups), [Personal data fields (PDFS)](#personal-data-fields-pdfs),
   [Divisions](#divisions), [Roles](#roles), [Competencies](#competencies), [Card
   types](#card-types), [Items](#all-the-above-are-items), [Events and alarms](#events-and-alarms),
   [Operator privileges](#operator-privileges), [HTTP requests](#http-requests) (GET, POST, PATCH,
   DELETE, headers, and bodies), [JSON](#json).
2. [Set up Command Centre](#set-up-command-centre)
      1. [Turn on the web server](#turn-on-the-web-server)
      3. [Create a REST operator](#create-a-rest-operator)
      3. [Create a REST Client item](#create-a-rest-client-item)
      3. [What is an API key?](#what-is-an-api-key)
1. [Try the sample client application](#try-the-sample-client-application)
2. [Set up Chrome](#set-up-chrome)
2. [Set up Postman](#set-up-postman)
2. [First GETs:  cardholders](#first-gets--cardholders):  get the API's contents page, get all
   cardholders, get one cardholder.
2. [First GETs:  events](#first-gets--events):  list all events, list all alarms
2. [Back into the theory](#back-into-the-theory)
2. [First POST and search](#first-post-and-search):  create a cardholder and search for it.

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

> Special notes use Markdown's type of quoting, like this.

## Exclusions

This document does not cover special handling of PIV cards.  It shows how to create a generic card
and leaves the variations for PIV and PIV-I to the developer documentation.

Nor does it cover some of the features added after v7.90:  access zones, alarm zones, fence zones,
doors, outputs, inputs, PDF definitions, macros, changing cardholder zones, operators, visitors,
schedules, and subscribing to cardholder updates.

# References

[devdocslong]: https://gallaghersecurity.github.io/ "Developer reference documentation on Github.io"
[devdocs]: .. "Developer reference documentation on Github.io"

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
`Setup\Program Files\Gallagher\Command Centre\Bin\Resources\en`.  There is a PDF version, split into
three volumes, on the ISO in the Documentation folder.

The Command Centre hardening guide, also on the ISO, is required reading for security-conscious
sites.  While you may not be able to follow its leading advice regarding the REST API (‘leave it
turned off’) there is plenty more in there to be aware of.

If you are interested in the security of the REST API, look in TODO_LINK for how the server
authenticates and authorises requests in general, and TODO_LINK for how it authenticates clients
using certificates.

## Sample code
See `Utilities/REST API/REST API Sample Code.zip` in the Command Centre ISO.  There is a WPF client
in there and a console application in a C# Visual Studio solution.

# Training setup

If you wish to try the REST API for yourself, you will require:

* Command Centre 7.90 or later with a RESTCardholders licence, a RESTEvents licence if you are to
  examine events, RESTStatus if you are to look at site items, RESTOverrides if you want to override
  them, and RESTCreateEvents if you wish to create events.  This document does not cover the last
  three.
* A host capable of reaching port 8904 on Command Centre via HTTPS, or desktop access to the CC
  server itself.
* (Recommended) the sample REST client application from the Command Centre installation media (8.10
  onward).
* (Optional) the [Postman](https://postman.com) installer, or access to it on the internet.
* (Optional) Chrome and access to the internet for two extensions.
* (Optional) wget or curl.
* The [API developer documentation][devdocs].

<!--
#####################################################################################
Some people come to the API without knowing anything about CC.  Or even HTTP.
#####################################################################################
-->

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
except in [TODO_LINK which puts a cardholder in an operator group while setting up a REST client.
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

## Events and alarms
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

In the interests of security, you should give your REST operators (footnote:  _all_ operators) the
minimum privileges they require to achieve their task.

A table on TODO_LINK gives some examples of privileges you will need for various tasks.

## HTTP requests
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

## Authentication and encryption certificates
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
that, the client shows a warning.  You will have to [work around it in
Chrome](#ignore-server-certificate-warnings) and [work around it in
Postman](#never-mind-that-your-server-certificate-is-self-signed).  If you want to install your own
server key, the topic ‘Changing the Web Services’ in the Configuration Client’s online help shows
you how.

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

## Items versus a cardholder’s link to them
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

<!--
#####################################################################################
Setting up the SAD to receive REST calls.
#####################################################################################
-->

# Set up Command Centre

## Turn on the web server

Configuration client -> File -> Server Properties -> Web Services (about 15 down).

Enable the REST API and--for the moment--tick the checkbox to the right of the port.  It has a
different label from this screenshot in 8.50.  Have a good look at the status because it is the
first indication of trouble binding a socket.

![Enabling the public API](../../assets/server_props_turnon.png "Enabling the web server")

The Configuration Client’s online help covers this in the topic called 'Web Services'.

> Make sure 'Do not require pinned client certificates' is off in production.  In 8.50 it is called
> 'Enable REST Clients with no client certificate'.  Turn it off.

Requiring pre-shared certificates from clients is the best protection the server has against
attackers on its network.  Once you have written the basics of your application and it is connecting
to the server, come back here, untick that box, read section TODO_LINK18, and get your application
working again.

### Installing a custom server certificate
You do not need to install a custom server certificate for experimental development.  If you
eventually choose to do it, it all happens under a button that arrived in Command Centre after I
took the screenshot above, labelled ‘Manage Certificates’.  The Configuration Client’s online help
covers it in detail in a section called ‘Replacing the web service certificate’ in the ‘Changing the
Web Services’ topic.  You can either import a public/private key pair into Command Centre (which is
simple) or use the Windows Certificate Store (which uses Microsoft’s security instead of Command
Centre’s).  The summary of the Certificate Store process is:  you need to name your certificate
‘Gallagher Command Centre Server’ (please take care with the spelling), place it in the ‘Gallagher
Applications / Certificates’ folder of the Local Computer Certificate Store, and give Command Centre
the rights to use it.  The online help lays that out step by step.

## Create a REST operator

We will get to the reasons why in TODO_LINK10.2.

### Create an operator group and give it the necessary privileges

You can do this in either of the clients.

Give the group the lowest level privileges it needs.  For this exercise, you will need ‘Create and
Edit Cardholders’ and ‘Edit Alarms’.  ‘Modify Access Control’ and ‘View Site’ could be handy later.

![todo](../../assets/op_group_privs.png "todo")

> Not ‘Advanced User’.  Never ‘Advanced User’.

See TODO_LINKp57 for a table of privileges an operator needs for common tasks.

One group is enough for experimenting but when it comes to production, create an operator group for
each class of client you have connecting and give each group different privileges.  An operator can
be in more than one operator group; use this flexibility as you need.

### Create a cardholder and add it to the operator group
You can do this in either of the clients.

![todo](../../assets/op_group_members.png "todo")
 
In production, your operator should have a bare minimum of capabilities, so do not give it a card,
logon, password, or user code.  Do give it plenty of description about what it does, where it
connects from, and who to contact about it, because the people running the security system will not
be the people who run your software integrations and they will need all the help you can give them
when problems arise.

During development it helps to log in to the Command Centre clients sometimes, so I give the REST
operator a logon, password, and the ‘Launch Configuration Client’ privilege.

Now that you have an operator, you need to let the REST API use it.

## Create a REST Client item

...(in the server) and assign an operator.

We call it a ‘REST Client’ but it is really a mapping from an API key to an operator.  More on this
later.

Using the Configuration client, Configure -> Services and Workstations (at the bottom).  Right-click
menu -> New -> REST Client.

Set a name, then go to the ‘API Key’ tab.

Drag your new operator (Manage -> Cardholders) into the ‘REST Client Operator’ box.  That box looks
like it can hold more than one:  it cannot.

Take a note of the API key.  You will need it for your clients (the sample app, Chrome, or Postman).

![todo](../../assets/rest_client_api_key.png "todo")

IP filtering is a layer of security that makes it that much harder for an attacker to attack your
server.

![todo](../../assets/rest_client_ip_filtering.png "todo")

(A space is as good as a comma.)

## What is an API key?

Your client sends this to Command Centre with every request.  It is the username and password
combined.  Take care of it.  If someone steals your API key and you have not taken other precautions
(client certificates and IP filtering) they could masquerade as you.

If something makes an API call without an API key, or with an API key that Command Centre cannot
find on one of the REST Client items, CC will raise an error ‘A REST connection was attempted with
an invalid API key’.

When a client sends it to the server in an HTTP header it prepends ‘GGL-API-KEY’ and a space.  That
string is not part of the key and you should not use it in any of the places that expect an API key.
It is just there so the HTTP request conforms to an Internet standard.


<!--
#####################################################################################
Section five, TODO
#####################################################################################
-->

# Try the sample client application

This section needs fleshing out with proper prose, but until that happens the major points to cover
are:

The sample client is the quickest way to make sure CC is working properly.  For Windows users, it is
better than a web browser (which requires plugins and hides error messages) or Postman (which is
fiddly if the server is checking client certificates, and now requires online registration).

Find the sample client on the installation media under <tt>Utilities / REST API /
RESTClient_<i>version</i></tt>.  It has been there since 8.00.

It is not a Command Centre management application!  It is a library of sample code for developers,
which happens to compile and run.  You can check the status of many items, override most of them,
watch and create events, and create, look up, and move cardholders, but some features like lockers
and car parks are missing.

Watch the multi-coloured console to find out what URLs to use in your own requests.  Later versions
include options on the login screen to also show the JSON that the client is sending and receiving.

The source code for the demo app and a few others is on the installation media.

<!--
#####################################################################################
Chrome
#####################################################################################
-->

# Set up Chrome
If the sample GUI app works and you want to see the data that comes from Command Centre, a web
browser is all you need.  If you also want to create and change items you should skip this section
and install Postman.

There are two extensions you need to install for Chrome to be really useful.  One sends the API key
to the server, and the other dresses up the JSON that it sends back.

## Install the ModHeader extension

You need to set a custom header, because that is how we send the API key and without that Command
Centre will give you nothing.

Start by clicking the ‘Modify Headers’ icon in Chrome.  (Footnote:  confusingly, there is also an
extension called ‘Modify Headers’, which is different from ‘ModHeader’.  Use either.)

Set a header called Authorization with a value of GGL-API-KEY followed by a space and the API key
you took from the configuration client.  Note in the example below I have two headers ready to go,
only one of which is active.  They are too wide for the Modify Headers window (there are three more
characters).

In 7.90, both must be in upper case.

> Set a filter so that the header only goes to your Command Centre server.  Otherwise Facebook will
have your API key.

Use a URL pattern in the filter that all your queries will match but other web browsing will not.
ModHeader now uses regular expressions, so if you have dots in your hostname you must put
backslashes in front, `\.`.

![todo](../../assets/chrome_mod_header_setup.png "todo")

## Install a JSON viewer
Raw JSON straight from the server contains no whitespace, so it is not that easy to read.  There are
a few Chrome extensions that pretty-print JSON for you.  I use ‘Awesome JSON Viewer’ because it is
recent (April 2020) and can collapse and count sub-items.  It is rebranding itself ‘JSON Viewer
Pro’, so you might try searching for that.  Despite having ‘pro’ in the name it remains free.

## Ignore server certificate warnings
Send Chrome to <tt>https://<i>your_host</i>:<i>your_port</i>/</tt> .  <tt><i>your_port</i></tt> is
probably 8904.  If your server does not have a certificate with a trust path to a trusted root
certificate, you need to click through the warning below.  It will reappear occasionally.  You can
turn it off in Chrome but it is not a good idea, since you want to know when other servers are using
self-signed certificates.

![todo](../../assets/chrome_bad_server_cert_1.png "todo")
![todo](../../assets/chrome_bad_server_cert_2.png "todo")

# Set up Postman

If you want to do more than look, you need Postman, because Chrome does not let you POST, PATCH, or
DELETE as easily as Postman does.

Postman used to be a Chrome extension but is now a standalone application.  Both work.  These
screenshots are from the application.

## Send the API header with every request
This is what the Modify Headers extension does in Chrome.  It makes Postman send an Authorization
header containing your API key with every request.

Your requests also need a Content Type header but you do not need to set it yourself.  Postman will
add that after the next step.

![todo](../../assets/postman_auth_header.png "todo")

**There is a mistake in that screenshot**:  the value for the Authorization header should have
GGL-API-KEY and a space before the API key.

<!-- don't change this header -->
## Never mind that your server certificate is self-signed
In the current version of Postman, the settings are behind the cog in the top tool bar, not the
sliders in the environment toolbar below it.

For older versions of Postman, the settings are behind the open-ended wrench in the top tool bar,
not the cog in the environment toolbar below it.

![todo](../../assets/postman_server_cert_warning_off_1.png "todo")
 
Pick ‘Settings’ and turn off SSL certificate verification.  Turn off the other options if you want
to keep it looking clean.  It makes no difference to Command Centre.

![todo](../../assets/postman_server_cert_warning_off_2.png "todo")




# First GETs:  cardholders
## The most basic GET
Using Chrome, go to <tt>https://<i>your_server</i>:8904/api</tt> again.  This document and the
developer documentation use the following shorthand, which omits the protocol, host, and port:

    GET /api

Doing that will test everything you have set up so far.  If it did not work, look at the error
message in the response body (Chrome will show it) and the most recent events in Command Centre.

If it did accept your API key, the only thing that can stop you now is a licensing problem:

    {
        "message": "feature not licensed"
    }

With a RESTEvents licence:

    {
        "version": "7.90.0.0",
        "features": {
            "items": {2 items},
            "alarms": {3 items},
            "events": {4 items}
        }
    }

With a RESTCardholdersEvents licence:

    {
        "version": "7.90.0.0",
        "features": {
            "items": {2 items},
            "alarms": {1 item},
            "cardholders": {1 item},
            "events": {1 item},
            "accessGroups": {1 item},
            "roles": {1 item},
            "lockerBanks": {1 item},
            "competencies": {1 item},
            "cardTypes": {1 item}
        }
    }

That is not the exact JSON you will get -- it's not even JSON -- but hopefully you get the idea.

## Cardholder summary

    GET /api/cardholders

That translates to <tt>https://<i>your_host</i>:<i>your_port</i>/api/cardholders</tt> in Chrome or
Postman.

Your operator should be there.  Try following some of the links.  If you are using Chrome, just
click on them.

    GET /api/cardholders?top=1

That limits it to one cardholder.  If you don’t have a next link in the result, it will be because
there is only one cardholder in your system or your operator only has access to one.

Now apply the advice from the efficiency section of the developer documentation for collecting a lot
of cardholders at once:

    GET /api/cardholders?sort=id&top=10000

v8.00 delivered the ability to add all the fields from the details page to the summary page, using
the fields parameter.  See the developer documentation for a proper description, but in short, try
adding <tt>fields=<i>fieldname</i></tt> to your request URL (after a `?` or `&` of course) where
<tt><i>fieldname</i><tt> is the name of a field you can see in a detail page, such as `cards` or
`accessGroups`.  For example:

    GET /api/cardholders?sort=id&top=10000&fields=firstName,lastName,cards

## Hrefs are URLs as well as identifiers

Notice the fields called href in the cardholder summary?  They are URLs, and hopefully you have
followed one already.  Some will return you a page of data, and some will 404.  We call them _hrefs_
rather than URLs because they are HTML references that, in our case, happen to be HTTPS URLs.

Hrefs are very important.  Each object in Command Centre -- events, alarms, items, connections
between them -- has one that identifies it.  You will be sending many of them in the bodies of your
requests.

## Cardholder detail

Follow one of the href links on the summary page:

    GET /api/cardholders/1234
    
1234 will be a different number on your system.  The API documentation uses the syntax
`/api/cardholders/{id}`.  Ignore the braces!  There are no braces in our URLs.

That GET shows you everything the REST API can tell you about the cardholder (footnote:  not quite
everything.  Mobile credentials and PIV and PIV-I cards have blobs of data that do not come out
unless you ask for them, because they are so large).  The developer documentation helps interpret
it.

> This is the difference between a summary page and a detail page.

The API documentation makes heavy use of the terms _summary_ and _detail_.  You see the summary of
an item at root URLs such as `/api/cardholders` and `/api/access_groups`, returned in an array of
many items of the same type as the results of a search.  You see the detail of a lone item by
following the item’s href.

It worth becoming familiar with the structure of a cardholder in JSON because the REST API uses it
for summary and detail pages, and it expects very nearly the same structure when you create or
modify a cardholder.  They vary in the quantity of fields and their levels in the document.




# First GETs:  events

## List all events
This returns 1000, starting with the first recorded:

    GET /api/events
    
If it takes a while, it is because the JSON viewer extension in Chrome is pretty-printing it.

From there you can following the `next` link to get another thousand.  When you have extracted all
the events out of Command Centre, an `updates` link will replace `next`.  The `updates` URL is a
long poll link:  GETting it will block until more events arrive, or the call times out.

If you are writing a program that will extract all events out of Command Centre you should set `top`
(described in the API documentation) as high as you can.  Command Centre will cap it at 10,000.  You
do not gain much performance after a couple of thousand, but taking it higher reduces the number of
requests.

    GET /api/events?top=5000

## List all alarms

The alarms interface only returns alarms that have not been processed, i.e., those that are
‘current’.  After an operator processes an alarm, it is merely an event with extra fields.

    GET /api/alarms

That will return at most 100 alarms.  You can follow the `next` link to get more, until you have got
them all and an `updates` link replaces it.  The `updates` URL is a long poll:  GETting it will
block until more alarms occur or the call times out.



# Back into the theory

## API controllers
_Controllers_ are different parts of the REST API.  Not to be confused with the controller hardware
Gallagher also produces, API controllers have the same name as the part of the request URL after the
leading `/api`.  The main ones are `alarms`, `events`, and `cardholders`.  `items` is there to
support searching for events.  `card_types`, `competencies`, `access_groups`, `roles`,
`operator_groups`, and `locker_banks` let you find items to attach to cardholders.

All controllers’ names are plural, and pothole_cased.  You can find links to them all with

    GET /api

## Why we need an operator
Everything that happens to a cardholder happens because an operator did it.  The operator could be a
person working in one of the thick clients, or it could be one of the other APIs, but whenever a
cardholder changes, Command Centre must have an operator to pin it on.

Having an operator allows Command Centre to enforce privileges.  You limit what your REST operator
can do in case the client has bugs (and starts DELETEing URLs instead of GETting them) or the API
key becomes known to the other side.

It also helps auditing.  Each cardholder change causes an operator event, with the operator and
cardholders as related items.  Interactive changes use the workstation as the source, and REST
changes use the REST Client.  You can run reports that filter on the source and operator to monitor
your integration.

## The request process
All HTTPS requests start like this:

1. The client and server establish an encrypted channel.  Part of that is a certificate exchange.
   The channel makes the following conversation safe from eavesdroppers but does not confirm the
   identity of either side.
2. Unless you have configured your client not to, it verifies the identity of the server
   (authenticates it) by examining the contents of the certificate that came from the server during
   the previous step.  If the client does not like the certificate that came from the server, it
   drops the connection.  Command Centre will complain to its log file when this happens but because
   it did not receive a request, will not create an event.
3. If the client trusts the server it sends its request along with a secret that proves it is who it
   says it is.  In our case that is an HTTP header containing the API key.

So far that has been a normal HTTPS conversation, the same as what happens with every web site you
visit in a browser.  From here on is specific to Command Centre.

4. The server looks for the API key in the authorization header and finds the matching REST Client
   (footnote:  capitalised to mean the configuration item in Command Centre, not the REST client
   software on the other end of the TCP connection) in the database.  If it cannot find one, it will
   raise an alarm ‘A REST connection was attempted with an invalid API key’.

5. If you did not disable pinned client certificates in the server properties (Web Services tab), or
   if you are running 8.50 and the REST Client item has a thumbprint on it (in the API Key tab), it
   checks the thumbprint of the request’s certificate against the one on the REST Client item.  If
   it does not match, it responds with a 401 and raises an alarm ‘A REST connection was attempted
   with an invalid client certificate’.  The server does not check the client certificate’s chain of
   trust.  Section TODO_LINK18 has all the details of why you would want your server to check client
   certificates and how to create them.

6. It checks the source host’s IP number against the REST Client item’s IP filters.  If it does not
   match, it responds with a 401 and raises an alarm ‘A REST connection was refused because of the
   connecting IP address does not match the IP filter on the REST Client ‘_name of your REST
   Client_’’.

7. It checks that it has a license for the controller that will handle the request.  If it does not,
   it sends a 403 response containing the string ‘Feature not licensed’.

8. It creates a new session for the operator, if there isn’t one ready, then compares what the
   request is asking for against the REST Client’s operator’s privileges from the session.  If the
   privileges do not allow the operation that the client requested, the server will respond with a
   400-level error and a message in the body.

If all those steps succeed, the API controller processes the request, logs an operator event if
something changed, and returns a result.

The alarms above have a default priority of medium-high.  The server raises them for two reasons:
while developing, it is useful to have a little more diagnosis coming out of the server, and in
production, it is good to know when your API is being probed.

If too many bad requests arrive too quickly, the server will assume it is under attack and will log
an alarm at maximum priority, then will remain silent on the matter until the attack stops.

Errors also go to `%PROGRAMDATA%\Gallagher\Command Centre\Command_centre.log`.



# First POST and search
## Create a cardholder
In Postman:

![todo](../../assets/postman_create_cardholder_1.png "todo")

Notice that there are two headers set:  `authorization` contains the API key and `content type`
tells the server that the body is JSON.

This document uses this shorthand to represent that kind of HTTP query:

    POST /api/cardholders
    {
        "firstName": "New",
        "lastName": "Cardholder",
        "division": {
            "href":"https://localhost:8904/api/divisions/2"
        }
    }

The first line gives the verb and the file part of URL.  It needs the protocol, host, and port
prepended:  <tt>https://<i>your_server</i>:8904</tt>.  The rest is the body.

When you create a cardholder you must specify the division and either the first or last name, so
this example is about the shortest you can get away with.

Look at the response from the POST.  It contains a `Location` header giving the URL of our new cardholder.

![todo](../../assets/postman_create_cardholder_result.png "todo")

You could GET that URL to see what you created, or...

## Search for a cardholder

    GET /api/cardholders?name=new
    
That will return all the cardholders with ‘new’ in their name.  It is case-insensitive.

To be more precise:

    GET /api/cardholders?name="cardholder, new"

Quotes make it a full string match, rather than a substring match.  It is still case-insensitive.

Note how Command Centre matches your search string against a concatenation of the cardholder’s last
name, a comma, a space, and the first name.  It only does that if the cardholder has both names set.
Otherwise it just uses the one.

Also note that Chrome will turn the space into `%20`.

You should see your new cardholder in the results of both those queries.
