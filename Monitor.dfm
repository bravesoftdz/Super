�
 TFRMMONITOR 0+&  TPF0TfrmMonitor
frmMonitorLeftPTop CaptionMonitorClientHeight ClientWidth� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
KeyPreview	OldCreateOrder	PositionpoScreenCenter
PrintScalepoNoneScaledWindowStatewsMaximizedOnClose	FormCloseOnCreate
FormCreate	OnKeyDownFormKeyDownOnShowFormShowPixelsPerInch`
TextHeight TPanelPanel1Left Top�Width� Height~AlignalBottom
BevelInner	bvLoweredColor��� TabOrder  TLabelLabel1LeftTopWidthHeightCaption6Maximum number of samples being monitored at once : 25Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel3LeftTopWidthHeightCaption7Maximum number of checks being monitored at once :   25Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel4LeftTop$Width� HeightCaption5At this point, only MATCH is activated for MonitoringFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel2LeftTopiWidth(HeightCaptionDuration  TBitBtnbRunNowLeft	TopEWidthnHeightHint+Run against Master Table for all "R" markedCaptionActivate RunFont.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameMS Sans Serif
Font.Style 	NumGlyphs
ParentFontParentShowHintShowHint	TabOrder OnClickbRunNowClick  TMemomFilterLeft��TopWidth� HeightzAlignalRightColorclWhiteCtl3DFont.CharsetANSI_CHARSET
Font.ColorclNavyFont.Height�	Font.NameCourier New
Font.Style ParentCtl3D
ParentFontTabOrder  TEditeDurMSLeft;TopfWidth'HeightCtl3DParentCtl3DTabOrderText0	OnKeyDowneDurMSKeyDown  TButtonbRefreshLeft� TopFWidthUHeightCaption&RefreshTabOrderOnClickbRefreshClick  TMemomResetLefte�TopWidth#HeightzAlignalRightColor��� Ctl3DFont.CharsetANSI_CHARSET
Font.ColorclNavyFont.Height�	Font.NameCourier New
Font.Style ParentCtl3D
ParentFont	PopupMenupuTabOrder   TPanel	pnlCenterLeft Top Width� Height�AlignalTop
BevelInner	bvLoweredColor��� TabOrder TPanelpnlRCLeft�TopWidth� Height�AlignalRight
BevelInner	bvLoweredColor��� TabOrder  TMemomFilterResultLeftTopWidth� Height�AlignalClientCtl3DFont.CharsetANSI_CHARSET
Font.ColorclNavyFont.Height�	Font.NameCourier New
Font.Style ParentCtl3D
ParentFont	PopupMenupu
ScrollBars
ssVerticalTabOrder    TPanelpnlFDLeftTopWidthbHeight�AlignalLeft
BevelOuterbvNoneColorclInfoBkTabOrder 	TwwDBGriddbgTestLeft Top WidthbHeight�Selected.StringsLBID	6	Seq.C1	2	#1C2	3	#2C3	3	#3C4	3	#4C5	2	#5C6	3	#6HITCOUNT	3	H.C.B1	2	1B2	2	2B3	2	3B4	2	4B5	2	5B6	2	6B7	2	7B8	2	8B9	2	9B10	2	10B11	2	11B12	2	12B13	2	13B14	2	14B15	2	15B16	2	16B17	2	17B18	2	18B19	2	19B20	2	20B21	2	21B22	2	22B23	2	23B24	2	24B25	2	25B26	1	26B27	1	27B28	1	28B29	1	29B30	1	30B31	1	31B32	1	32B33	1	33B34	1	34B35	1	35B36	1	36B37	1	37B38	1	38B39	1	39B40	1	40B41	1	41B42	1	42B43	1	43 IniAttributes.Delimiter;;
TitleColor��� 	FixedColsShowHorzScrollBar	AlignalTopColorclInfoBkCtl3D
DataSourcedLBFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.Style Options	dgEditingdgTitlesdgIndicatordgColumnResize
dgRowLinesdgTabsdgConfirmDeletedgCancelOnExit
dgWordWrap ParentCtl3D
ParentFontTabOrder TitleAlignmenttaCenterTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
TitleLinesTitleButtons  TPanelPanel2Left Top�WidthbHeight+AlignalBottomTabOrder TLabellblTrackingNoLeftTopWidthfHeightCaptionTracking No. : Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TButtonbPrintResultLeft}Top
Width^HeightCaptionPrint Result ==>TabOrder OnClickbPrintResultClick     TPrintDialogPrintDialog1Left1TopE  
TPopupMenupuOnPopuppuPopupLeftTop/ 	TMenuItemmnuSavetoFileBumpCaptionSave to c:\1.txtOnClickmnuSavetoFileBumpClick  	TMenuItemmnuSaveToFileResetCaptionSave To c:\3.txtOnClickmnuSaveToFileResetClick   TADQueryqLBActive	
Connectiondm.ADConnectionTransactiondm.ADTransactionUpdateTransactiondm.ADTransactionSQL.Stringsselect * from labellist where lbid < 4 order by lbid Left(TopH TIntegerFieldqLBLBIDDisplayLabelSeq.DisplayWidth	FieldNameLBIDOriginLBIDProviderFlags
pfInUpdate	pfInWherepfInKey Required	  TSmallintFieldqLBC1DisplayLabel#1DisplayWidth	FieldNameC1OriginC1  TSmallintFieldqLBC2DisplayLabel#2DisplayWidth	FieldNameC2OriginC2  TSmallintFieldqLBC3DisplayLabel#3DisplayWidth	FieldNameC3OriginC3  TSmallintFieldqLBC4DisplayLabel#4DisplayWidth	FieldNameC4OriginC4  TSmallintFieldqLBC5DisplayLabel#5DisplayWidth	FieldNameC5OriginC5  TSmallintFieldqLBC6DisplayLabel#6DisplayWidth	FieldNameC6OriginC6  TIntegerFieldqLBHITCOUNTDisplayLabelH.C.DisplayWidth	FieldNameHITCOUNTOriginHITCOUNT  TStringFieldqLBB1DisplayLabel1DisplayWidth	FieldNameB1OriginB1	FixedChar	Size  TStringFieldqLBB2DisplayLabel2DisplayWidth	FieldNameB2OriginB2	FixedChar	Size  TStringFieldqLBB3DisplayLabel3DisplayWidth	FieldNameB3OriginB3	FixedChar	Size  TStringFieldqLBB4DisplayLabel4DisplayWidth	FieldNameB4OriginB4	FixedChar	Size  TStringFieldqLBB5DisplayLabel5DisplayWidth	FieldNameB5OriginB5	FixedChar	Size  TStringFieldqLBB6DisplayLabel6DisplayWidth	FieldNameB6OriginB6	FixedChar	Size  TStringFieldqLBB7DisplayLabel7DisplayWidth	FieldNameB7OriginB7	FixedChar	Size  TStringFieldqLBB8DisplayLabel8DisplayWidth	FieldNameB8OriginB8	FixedChar	Size  TStringFieldqLBB9DisplayLabel9DisplayWidth	FieldNameB9OriginB9	FixedChar	Size  TStringFieldqLBB10DisplayLabel10DisplayWidth	FieldNameB10OriginB10	FixedChar	Size  TStringFieldqLBB11DisplayLabel11DisplayWidth	FieldNameB11OriginB11	FixedChar	Size  TStringFieldqLBB12DisplayLabel12DisplayWidth	FieldNameB12OriginB12	FixedChar	Size  TStringFieldqLBB13DisplayLabel13DisplayWidth	FieldNameB13OriginB13	FixedChar	Size  TStringFieldqLBB14DisplayLabel14DisplayWidth	FieldNameB14OriginB14	FixedChar	Size  TStringFieldqLBB15DisplayLabel15DisplayWidth	FieldNameB15OriginB15	FixedChar	Size  TStringFieldqLBB16DisplayLabel16DisplayWidth	FieldNameB16OriginB16	FixedChar	Size  TStringFieldqLBB17DisplayLabel17DisplayWidth	FieldNameB17OriginB17	FixedChar	Size  TStringFieldqLBB18DisplayLabel18DisplayWidth	FieldNameB18OriginB18	FixedChar	Size  TStringFieldqLBB19DisplayLabel19DisplayWidth	FieldNameB19OriginB19	FixedChar	Size  TStringFieldqLBB20DisplayLabel20DisplayWidth	FieldNameB20OriginB20	FixedChar	Size  TStringFieldqLBB21DisplayLabel21DisplayWidth	FieldNameB21OriginB21	FixedChar	Size  TStringFieldqLBB22DisplayLabel22DisplayWidth	FieldNameB22OriginB22	FixedChar	Size  TStringFieldqLBB23DisplayLabel23DisplayWidth	FieldNameB23OriginB23	FixedChar	Size  TStringFieldqLBB24DisplayLabel24DisplayWidth	FieldNameB24OriginB24	FixedChar	Size  TStringFieldqLBB25DisplayLabel25DisplayWidth	FieldNameB25OriginB25	FixedChar	Size  TStringFieldqLBB26DisplayLabel26DisplayWidth	FieldNameB26OriginB26	FixedChar	Size  TStringFieldqLBB27DisplayLabel27DisplayWidth	FieldNameB27OriginB27	FixedChar	Size  TStringFieldqLBB28DisplayLabel28DisplayWidth	FieldNameB28OriginB28	FixedChar	Size  TStringFieldqLBB29DisplayLabel29DisplayWidth	FieldNameB29OriginB29	FixedChar	Size  TStringFieldqLBB30DisplayLabel30DisplayWidth	FieldNameB30OriginB30	FixedChar	Size  TStringFieldqLBB31DisplayLabel31DisplayWidth	FieldNameB31OriginB31	FixedChar	Size  TStringFieldqLBB32DisplayLabel32DisplayWidth	FieldNameB32OriginB32	FixedChar	Size  TStringFieldqLBB33DisplayLabel33DisplayWidth	FieldNameB33OriginB33	FixedChar	Size  TStringFieldqLBB34DisplayLabel34DisplayWidth	FieldNameB34OriginB34	FixedChar	Size  TStringFieldqLBB35DisplayLabel35DisplayWidth	FieldNameB35OriginB35	FixedChar	Size  TStringFieldqLBB36DisplayLabel36DisplayWidth	FieldNameB36OriginB36	FixedChar	Size  TStringFieldqLBB37DisplayLabel37DisplayWidth	FieldNameB37OriginB37	FixedChar	Size  TStringFieldqLBB38DisplayLabel38DisplayWidth	FieldNameB38OriginB38	FixedChar	Size  TStringFieldqLBB39DisplayLabel39DisplayWidth	FieldNameB39OriginB39	FixedChar	Size  TStringFieldqLBB40DisplayLabel40DisplayWidth	FieldNameB40OriginB40	FixedChar	Size  TStringFieldqLBB41DisplayLabel41DisplayWidth	FieldNameB41OriginB41	FixedChar	Size  TStringFieldqLBB42DisplayLabel42DisplayWidth	FieldNameB42OriginB42	FixedChar	Size  TStringFieldqLBB43DisplayLabel43DisplayWidth	FieldNameB43OriginB43	FixedChar	Size   TDataSourcedLBDataSetqLBLefthTopH   