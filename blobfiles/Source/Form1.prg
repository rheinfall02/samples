/*
 * Projekt: XailerBlob
 * Datei: Form1.prg
 * Beschreibung:
 * Autor:
 * Datum: 01-10-2021
 */

#include "Xailer.ch"
#include "blob.ch"

CLASS TForm1 FROM TForm

   COMPONENT oImage1
   COMPONENT oCdxDataSource1
   COMPONENT oDbfDataSet1
   COMPONENT oDBBrowse1
   COMPONENT oDBEdit1
   COMPONENT oBtnEdit
   COMPONENT oBtnLoadPicture
   COMPONENT oBtnNew

   METHOD CreateForm()
   METHOD Init( oSender )
   METHOD ShowImage( oSender, nKeyFlags, nPosX, nPosY )
   METHOD SkipRec( oSender, lBookMarkChanged )
   METHOD LoadPicture( oSender )
   METHOD RecEdit( oSender )
   METHOD RecNew( oSender )
   METHOD CheckFiles( oSender )

ENDCLASS

#include "Form1.xfm"

//------------------------------------------------------------------------------

METHOD Init( oSender ) CLASS TForm1
//
LOCAL aDBF := { {"FILE", "C", 30, 0}, {"Blob_Memo", "M", 10, 0} }
LOCAL nI, nLen  , nFieldPos , cPicture


   SET DELETED ON
   /*
   */


   ::oBtnLoadPicture:Hide()
   ::ShowImage(oSender)

RETURN Nil

//------------------------------------------------------------------------------

METHOD ShowImage( oSender, nKeyFlags, nPosX, nPosY ) CLASS TForm1
LOCAL oPicture AS CLASS TPicture

   IF ::oImage1:oPicture != NIL
      ::oImage1:oPicture:End()
   ENDIF

   //IF .not. Empty(  ::oDbfDataSet1:Blob_Memo)
         oPicture := TPicture():New( Self )
         oPicture:LoadFromStream( ::oDbfDataSet1:Blob_Memo )
   //ENDIF
   ::oImage1:oPicture := oPicture
RETURN Nil

//------------------------------------------------------------------------------

METHOD SkipRec( oSender, lBookMarkChanged ) CLASS TForm1
LOCAL oPicture AS CLASS TPicture

   IF ::oImage1:oPicture != NIL
      ::oImage1:oPicture:End()
   ENDIF

   oPicture := TPicture():New( Self )
   oPicture:LoadFromStream( ::oDbfDataSet1:Blob_Memo )
   //MsgInfo(oPicture)
   ::oImage1:oPicture := oPicture

RETURN Nil

//------------------------------------------------------------------------------

METHOD LoadPicture( oSender ) CLASS TForm1
   LOCAL nFieldNr, nLenPath,  cFilePicture , cFile , cCuttedFile

   WITH OBJECT TFileOpenImageDlg():New( Self )
      IF ! Empty( ::oImage1:oPicture )
         :cFileName := ::oImage1:oPicture:cName
      ENDIF
      IF :Run()
         ::oDbfDataSet1:RecLock()
         cFile:= :cFileName
         nFieldNr := ::oDbfDataSet1:FieldPos("BLOB_MEMO")
         BLOBImport(nFieldNr,cFile)
         ::oDbfDataSet1:RecUnLock()
        // ::oDBBrowse1:RefreshCurrent()
      ENDIF
   END
RETURN Nil

//------------------------------------------------------------------------------

METHOD RecEdit( oSender ) CLASS TForm1
   If !::oDbfDataSet1:lOnEdit()
      ::oDbBrowse1:lEnabled := .f.
      ::oDbfDataSet1:Edit()
      ::oBtnEdit:cText := "Speichern"
      ::oBtnNew:Hide()
      ::oBtnLoadPicture:Show()
      ::oDbEdit1:SetFocus()
   else
      ::oDbfDataSet1:Update()
      ::oBtnEdit:cText := "Bearbeiten"
      ::oBtnLoadPicture:Hide()
      ::oBtnNew:Show()
      ::oDbBrowse1:lEnabled := .t.
      ::oDbBrowse1:RefreshCurrent()
      ::oDbfDataSet1:Skip(-1)
      ::oDbfDataSet1:Skip()
      ::oDbBrowse1:SetFocus()
   Endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD RecNew( oSender ) CLASS TForm1
   ::oDbfDataSet1:Append()
   ::oImage1:oPicture   := NIL

   ::RecEdit(oSender)

RETURN Nil

//------------------------------------------------------------------------------


METHOD CheckFiles( oSender ) CLASS TForm1
LOCAL aDBF := { {"FILE", "C", 30, 0}, {"Blob_Memo", "M", 10, 0} }
REQUEST DBFCDX, DBFFPT
rddSetDefault( "DBFCDX")
   IF .NOT. File("Blob_B32.dbf" )
         DBCreate("Blob_B32", aDBF)
         USE "Blob_b32.dbf"
         //::oDbfDataSet1:AddIdxFile("Blob_B32")
         //::oDbfDataSet1:AddTag("Blob_B32","File")
         DBCREATEINDEX( "Blob_B32", "File")

         DBAppend()
         blob_B32->file := "Hallo"
         DBCLOSEAREA()
   ENDIF
   IF .NOT. File("Blob_B32.cdx" )
          MsgInfo("keine Indexdatei vorhanden")
   //       MsgInfo(::oDbfDataSet1:lOpen)
         //DBUseArea( "Blob_b32.dbf")
         //DBCREATEINDEX( "Blob_B32", "File")
         ::oDbfDataSet1:AddTag("Name","File")
         //DBCLOSEAREA()
   ENDIF
   */
RETURN Nil

//------------------------------------------------------------------------------
