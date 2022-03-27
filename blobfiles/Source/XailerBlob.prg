/* 
 * Projekt: XailerBlob
 * Datei: XailerBlob.prg
 * Beschreibung: Startmodul der Applikation
 * Autor:
 * Datum: 01-10-2021
 */

#include "Xailer.ch"

Procedure Main()

   Application:cTitle := "XailerBlob"
   TForm1():New( Application ):Show()
   Application:Run()

Return
