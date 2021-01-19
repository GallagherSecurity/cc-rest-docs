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

Sample table

| Enabled flag | Enablement date | Expiry date | `status.type`
| ------------ | -------------- | --------| ----- |
| true | - | Far future | active |
| true | - | Near future | expiryDue |
| true | - | Past | expired |
| false | Future | - | pending |
| false | Past | - | inactive |
| false | null | - | inactive |

Sample image

![text](../../assets/server_props_turnon.png "title")

Trailer.

