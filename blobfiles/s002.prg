/*
 * BLOB Sample n� 2
 * Author: Fernando Yurisich <fyurisich@oohg.org>
 * Licensed under The Code Project Open License (CPOL) 1.02
 * See <http://www.codeproject.com/info/cpol10.aspx>
 *
 * This sample shows how to store an image into a BLOB field
 * and how to show it using an IMAGE control.
 *
 * Visit us at https://github.com/oohg/samples
 */

#include "oohg.ch"
#include "blob.ch"

FUNCTION Main

   LOCAL aStruct := { {"CODE", "N", 3, 0}, {"IMAGE", "M", 10, 0} }
   LOCAL cInput  := "Input.ico"
   LOCAL oForm
   LOCAL oImage

   REQUEST DBFCDX, DBFFPT
   rddSetDefault( "DBFCDX")

   dbCreate( "IMAGES", aStruct )

   USE IMAGES NEW
   APPEND BLANK
   REPLACE code WITH 1

   // Import
   IF ! BLOBImport( FieldPos( "IMAGE" ), cInput )
      ? "Error importing !!!"
      RETURN NIL
   ENDIF

   // Show
   DEFINE WINDOW Form_1 ;
      OBJ oForm ;
      AT 0,0 ;
      WIDTH 588 ;
      HEIGHT 480 ;
      TITLE 'Show image from BLOB file' ;
      MAIN ;
      ON RELEASE ( dbCloseAll(), dbCommitAll() )

      @ 10, 10 IMAGE Img_1 ;
         OBJ oImage ;
         IMAGESIZE ;
         PICTURE "demo.ico"

      @ 80, 10 BUTTON Btn_1 ;
         CAPTION "Change image" ;
         ACTION oImage:Buffer := BLOBGet( FieldPos( "IMAGE" ) )

      ON KEY ESCAPE ACTION oForm:Release()
   END WINDOW

   oForm:Center()
   oForm:Activate()

   CLOSE DATABASES

   IF MsgYesNo( "Erase auxiliary file?" )
      FErase( "IMAGES.FPT" )
      FErase( "IMAGES.DBF" )
   ENDIF

RETURN NIL

/*
 * EOF
 */
