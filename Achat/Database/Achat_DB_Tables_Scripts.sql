
CREATE TABLE  "SITES" 
   (	"SITEID" VARCHAR2(2) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20), 
	 PRIMARY KEY ("SITEID") ENABLE
   ) 


CREATE TABLE  "CATEGORY" 
   (	"CATEGORY" VARCHAR2(4) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20), 
	 PRIMARY KEY ("CATEGORY") ENABLE
   ) 

CREATE TABLE  "GROUPS_ACHAT" 
   (	"GROUPID" NUMBER(3,0), 
	"DESCRIPTION" VARCHAR2(20), 
	 CONSTRAINT "GROUPS_ACHAT_CON" PRIMARY KEY ("DESCRIPTION") ENABLE
   ) 


CREATE TABLE  "USERS_ACHAT" 
   (	"USERID" VARCHAR2(4) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20), 
	"EMAIL" VARCHAR2(50), 
	"PASSWORD" VARCHAR2(64), 
	"STATUS" VARCHAR2(1) NOT NULL ENABLE, 
	 PRIMARY KEY ("USERID") ENABLE
   ) ;ALTER TABLE  "USERS_ACHAT" ADD CONSTRAINT "USERS_ACHAT_CON" FOREIGN KEY ("DESCRIPTION")
	  REFERENCES  "GROUPS_ACHAT" ("DESCRIPTION") ENABLE




CREATE TABLE  "PRODUCT" 
   (	"BARCODE" VARCHAR2(16) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20) NOT NULL ENABLE, 
	"TVA" NUMBER(10,3) NOT NULL ENABLE, 
	"TVA_TYPE" VARCHAR2(1) NOT NULL ENABLE, 
	"STATUS" VARCHAR2(1) NOT NULL ENABLE, 
	"CATEGORY" VARCHAR2(4), 
	"USERID" VARCHAR2(4), 
	 PRIMARY KEY ("BARCODE") ENABLE
   ) ;ALTER TABLE  "PRODUCT" ADD CONSTRAINT "FK_PRODUCT_1" FOREIGN KEY ("CATEGORY")
	  REFERENCES  "CATEGORY" ("CATEGORY") ENABLE;ALTER TABLE  "PRODUCT" ADD CONSTRAINT "FK_PRODUCT_2" FOREIGN KEY ("USERID")
	  REFERENCES  "USERS_ACHAT" ("USERID") ENABLE




CREATE TABLE  "SUPPLIER" 
   (	"SUPPLIERID" NUMBER(5,0) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(20) NOT NULL ENABLE, 
	"TEL" VARCHAR2(20), 
	"EMAIL" VARCHAR2(50), 
	"STATUS" VARCHAR2(1) NOT NULL ENABLE, 
	"ADDRESS" VARCHAR2(100), 
	"USERID" VARCHAR2(4), 
	 PRIMARY KEY ("SUPPLIERID") ENABLE
   ) ;ALTER TABLE  "SUPPLIER" ADD CONSTRAINT "SUPPLIER_CON" FOREIGN KEY ("USERID")
	  REFERENCES  "USERS_ACHAT" ("USERID") ENABLE




CREATE TABLE  "SUPPLIER_PRODUCTS" 
   (	"BARCODE" VARCHAR2(16) NOT NULL ENABLE, 
	"SUPPLIERID" NUMBER(5,0) NOT NULL ENABLE, 
	"USERID" VARCHAR2(4) NOT NULL ENABLE, 
	 PRIMARY KEY ("BARCODE", "SUPPLIERID", "USERID") ENABLE
   ) ;ALTER TABLE  "SUPPLIER_PRODUCTS" ADD CONSTRAINT "FK_SUPPLIER_PRODUCTS_1" FOREIGN KEY ("BARCODE")
	  REFERENCES  "PRODUCT" ("BARCODE") ENABLE;ALTER TABLE  "SUPPLIER_PRODUCTS" ADD CONSTRAINT "SUPPLIER_PRODUCTS_CON" FOREIGN KEY ("USERID")
	  REFERENCES  "USERS_ACHAT" ("USERID") ENABLE;ALTER TABLE  "SUPPLIER_PRODUCTS" ADD CONSTRAINT "SUPPLIER_PRODUCTS_FK_SUPP" FOREIGN KEY ("SUPPLIERID")
	  REFERENCES  "SUPPLIER" ("SUPPLIERID") ENABLE



CREATE TABLE  "PURCHASES" 
   (	"DOCID" NUMBER(5,0), 
	"SITEID" VARCHAR2(2), 
	"TRSDATE" DATE, 
	"SUPPLIERID" NUMBER(5,0), 
	"USERID" VARCHAR2(4), 
	"DONE" VARCHAR2(1), 
	 CONSTRAINT "PURCHASES_CON" PRIMARY KEY ("DOCID") ENABLE
   ) ;ALTER TABLE  "PURCHASES" ADD CONSTRAINT "PURCHASES_CON_FK_SUPP" FOREIGN KEY ("SUPPLIERID")
	  REFERENCES  "SUPPLIER" ("SUPPLIERID") ENABLE;ALTER TABLE  "PURCHASES" ADD CONSTRAINT "PURCHASES_FK" FOREIGN KEY ("SITEID")
	  REFERENCES  "SITES" ("SITEID") ENABLE;ALTER TABLE  "PURCHASES" ADD CONSTRAINT "PURCHASES_FK4" FOREIGN KEY ("USERID")
	  REFERENCES  "USERS_ACHAT" ("USERID") ENABLE


CREATE TABLE  "PURCHASES_DTL" 
   (	"DOCID" NUMBER(5,0), 
	"BARCODE" VARCHAR2(16), 
	"QTY" NUMBER(8,0), 
	 CONSTRAINT "PURCHASES_DTL_PK" PRIMARY KEY ("DOCID", "BARCODE") ENABLE
   ) ;ALTER TABLE  "PURCHASES_DTL" ADD CONSTRAINT "PURCHASES_DTL_CON" FOREIGN KEY ("BARCODE")
	  REFERENCES  "PRODUCT" ("BARCODE") ENABLE;ALTER TABLE  "PURCHASES_DTL" ADD CONSTRAINT "PURCHASES_DTL_FK_DOCID" FOREIGN KEY ("DOCID")
	  REFERENCES  "PURCHASES" ("DOCID") ENABLE



CREATE TABLE  "RECEPT" 
   (	"DOCID" VARCHAR2(14) NOT NULL ENABLE, 
	"SITEID" VARCHAR2(2), 
	"TRSDATE" DATE, 
	"RELATED_DOCID" NUMBER(5,0), 
	"INVOICE_DISCOUNT" NUMBER(4,2), 
	 PRIMARY KEY ("DOCID") ENABLE
   ) ;ALTER TABLE  "RECEPT" ADD CONSTRAINT "FK_RECEPT_1" FOREIGN KEY ("SITEID")
	  REFERENCES  "SITES" ("SITEID") ENABLE;ALTER TABLE  "RECEPT" ADD CONSTRAINT "RECEPT_CON_FK_DOCID" FOREIGN KEY ("RELATED_DOCID")
	  REFERENCES  "PURCHASES" ("DOCID") ENABLE



CREATE TABLE  "RECEPT_DTL" 
   (	"DOCID" VARCHAR2(14), 
	"BARCODE" VARCHAR2(16), 
	"QTY" NUMBER(11,2), 
	"PURCHASE_PRICE" NUMBER(10,3), 
	"ITEM_DISCOUNT" NUMBER(4,2), 
	 CONSTRAINT "RECEPT_DTL_CON" PRIMARY KEY ("DOCID", "BARCODE") ENABLE
   ) ;ALTER TABLE  "RECEPT_DTL" ADD CONSTRAINT "FK_RECEPT_DTL_1" FOREIGN KEY ("DOCID")
	  REFERENCES  "RECEPT" ("DOCID") ENABLE;ALTER TABLE  "RECEPT_DTL" ADD CONSTRAINT "FK_RECEPT_DTL_2" FOREIGN KEY ("BARCODE")
	  REFERENCES  "PRODUCT" ("BARCODE") ENABLE



CREATE TABLE  "STK_PRD" 
   (	"SITEID" VARCHAR2(2), 
	"BARCODE" VARCHAR2(16), 
	"QTY" NUMBER(5,0), 
	"QTY_NOTIFICATION" NUMBER(5,0), 
	 CONSTRAINT "STK_PRD_PK" PRIMARY KEY ("SITEID", "BARCODE") ENABLE
   ) ;ALTER TABLE  "STK_PRD" ADD CONSTRAINT "STK_PRD_FK" FOREIGN KEY ("SITEID")
	  REFERENCES  "SITES" ("SITEID") ENABLE;ALTER TABLE  "STK_PRD" ADD CONSTRAINT "STK_PRD_FK2" FOREIGN KEY ("BARCODE")
	  REFERENCES  "PRODUCT" ("BARCODE") ENABLE



CREATE TABLE  "STK_TRS" 
   (	"SITEID" VARCHAR2(2) NOT NULL ENABLE, 
	"DOCID" VARCHAR2(14) NOT NULL ENABLE, 
	"TRSDATE" DATE NOT NULL ENABLE, 
	"DOCTYPE" VARCHAR2(1) NOT NULL ENABLE, 
	"BARCODE" VARCHAR2(8) NOT NULL ENABLE, 
	"QTY" NUMBER(5,0) NOT NULL ENABLE, 
	"RELATED_DOCID" VARCHAR2(14), 
	"TVA" NUMBER(10,3), 
	"TVA_TYPE" VARCHAR2(1), 
	"SUPPLIERID" VARCHAR2(5), 
	"USERID" VARCHAR2(4) NOT NULL ENABLE, 
	"PURCHASE_PRICE" NUMBER(10,3)
   ) 


