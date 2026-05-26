Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE33F421898;
	Tue, 26 May 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779817990; cv=fail; b=Y1WcfTd3jC9I7xk/Pr26FtRMeQkpB0o78qbQTzpq6vaNcITODPOucvdA/MAA2IGd+bohy9H6r46sH+HZuM70mXPEtBy67LmkA4tfvA3uQoEOBTmsN5xUKH3KK5/sXoAasDxqtf1O1IrCegUtRiBlc7UYnLuU8m1wCt59m0+6NR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779817990; c=relaxed/simple;
	bh=MgeYBfvKRk8vDTCDlLhDSJ8lmfpWzxhr5Dq/juRrYlE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ZumH9sAsi4lAb/gNUqOpdxjudxuqjuSrKDdgzSo0GXaG0pkkdRVr2SFivjhZNmj5ncmF76JHDORLgGjrevJQly1xbDpGZtoMgvoLypxO/UScQbkmJ2xFjIn7YoKYIgQTG9BfoFY8nbHh0UazUlEGryGrgP/tvRFJA5rsGsvheVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UteTNxrK; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UteTNxrK"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q79poa776270;
	Tue, 26 May 2026 17:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=MgeYBfvKRk8vDTCDlLhDSJ8lmfpWzxhr5Dq/juRrYlE=; b=UteTNxrK
	ga0Rq7lVDSAxofEj4Pf3pZ7nhk6PvhioV2dGo1CDKlx5oqEFTwO06onh9I+b/ZMh
	hlK/LCt7NjU2HxhSvtJBYU6dJPMfy1zjCTC8wcYiivvRMSXoC6vNARAUc8AvKvbH
	/BFT8oeUKqXkPDAtD/n0LmQYlCUJyEXYiMme1urQaffTwa2V9HVPAHK1wfoSiaFD
	MEOT/+z46f4wR9XMhsMv88fZ/FZSlSBI7c5SZ0QlNlz9ZQU+s+oPKKwp2uHc3ThY
	X/ZxCVzkWYMKpzQJGKphg0xV58K63+oKEulOnYQ80Hf6UWxLljVJ/rUJXl2o046X
	kW1O5n+R5Hdimw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4qbwhcp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:52:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DRfO5Ee9OGXB4r9wMHlfpEeIK1ou0V4PP7ZZmeVkuuvQk+dieWydKiA1uFiAweHwucSvFzWvVkaZA4S8K0cP7zoBVRNfr/LmH5WZEoIZsmBbGyeCaq9S/yPF5ioN8oFBtY7eELsPL8M0832pKtLx5BNmoIc0j8p9G/iJhkuHzbpcKa68qLIOcYn2QYwKSAl20bEImJfnuUSEj42UMlAxnEmkxnGG3vF76RUvts28VcGGRicgpFugV75RfTSdIgQ6vF2KDJfAF9/SBkChVtoohZGI7avWPHFU8Ci3JuUIqFIWMttvLbwfSYbYhrNDFnKwxlkDwQ90wtiSCvZ3V0Eu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgeYBfvKRk8vDTCDlLhDSJ8lmfpWzxhr5Dq/juRrYlE=;
 b=qugolpweIghRGOsc0tQhcLVLxy4VSxvEsQ9S4Y/wc9Q8J8Y9WbVg6u9vYk7KWj6adPCUkH66tm6mdH5qnkMo7+ajDZRsIFOu6X4g7Wp9h3pzR3NU4PRD40mRZLyMmoC4403Cs5jDjKqRcuEP5wUW9+TPDgm2aeIRWei1vRt5CMmfEtgM7CC1HxYbeta8H56H7EqAifVIY/de09wBasvVkZZYQdXF5/WSHpflQbhXmymdDeDwmeATHRXBJUjI1W3/QzoEFCa7kSmjijnNHaw/qMZhv1ul3PXNdNCTew7a6Uv+tMfGfItNr4Bdf5nHT3pr3g0vc++xfosvMRyfoH3+PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV3PR15MB6567.namprd15.prod.outlook.com (2603:10b6:408:273::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 17:52:56 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 17:52:56 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "jack@suse.cz" <jack@suse.cz>, "willy@infradead.org" <willy@infradead.org>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "hch@infradead.org"
	<hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 28/34] nilfs2: Convert
 nilfs_gccache_submit_read_data to bh_submit()
Thread-Index: AQHc7GtOAXWfmrVDo0ekFDuZ6ExYFrYgmB+A
Date: Tue, 26 May 2026 17:52:56 +0000
Message-ID: <41998b761c6b7968016365f499b1153a26c7cf17.camel@ibm.com>
References: <20260525171931.4144395-1-willy@infradead.org>
	 <20260525171931.4144395-29-willy@infradead.org>
In-Reply-To: <20260525171931.4144395-29-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV3PR15MB6567:EE_
x-ms-office365-filtering-correlation-id: fff707f6-6832-433b-daa8-08debb4f9e01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|4143699003|11063799006|18002099003|22082099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 DnS77IZbZDD1qHB3HO7sbCr5vhAAH3pUJQUhNKlVEoSR2ldv0Mhby4eInU/sZdbJeYFbJmsJl2IaF/6KbquPbaOVA7nfaDqu2b0cLPZUotjoYR28zotlJxHKbsVo81YB4j0I5ypiu5GjGvcVs+8Q4sPdP7ToHLsDgzcxKX4HwPWykC8CQHZRtgdLPtRtrrUmujep5EwKQ/iv2iQ9XLC/bq12ZiI41GIvLDZwfu/AcG/BPf9dKTNjT3AfmSqP1qf/UJ0TQ/Sbt2qqhsW3fu0ktmnLNZ4xzwhn5w9ENndMGjD2BvXm+M2Vx6x8J4vfa50SvxL4kCDww2skJCeQN4DTRbDtasrfx2xFkHWqXlzYpG2HTw8SyOVOTXR50Uvrnr2cB8vHExMx1zXRiAsvFsDg4hhhTTVyGI/NBy4juegy8h4ell77RYzeLGE87TWpkqjA2g+jvnW0fq1EykV43cO7Vvs3S88DxVW4388sedMaHgJn2rZbmDvYBYdI01+o3mw5g10QfcxhFYc5tKzuJ/NLRFYeT5tRIyFq0w5WO0Q4lx+wnx+WqBokthYLYSkhg9hLi4oM1aSZ0ZzhBFZZmlmfnCsbOEQRMnWFicdq6Dp0WxGzZT8YTD4DNkrXZhtX9OxfHmgvEOtwea4lJTN3a+VLc+N6QJUf+Br5peXv/UpV2tHS88zKFTIf1SHeoAGRlX+u9IdDPV/rtsNnu+zNcCqavEzMVn1jV2x5BWd4+mPAGlfC13zD0uFrkRAkj046NcIP
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(4143699003)(11063799006)(18002099003)(22082099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y2tjMitFVHk4cFV2OTRPQ3BTQlhVVUZrUFlmMXc4VlRDRUdRMUtEWWNUOCtU?=
 =?utf-8?B?alZUclJ1NkNlN2FkMFcyd28yYjUwU1FueEh5dGZXNEcxL2gyY2M4UDJPTTZQ?=
 =?utf-8?B?NXRtaitZRTNLTnU3SVcrTmlXVW1PQnpXQy9jbUlkblNhZXF0cldMTzd6bnQy?=
 =?utf-8?B?SHAwZm50ekwvaS9aR1dHeDJPblVtYkFhaU5BRm1scUF6Ly9SQ0YxSEZZa2tm?=
 =?utf-8?B?blhEdFcvZGtFeDdkc3R2QnRXdVoxenY2WlJCQ2VxRk1XeHRHb2l1SXdHdG5U?=
 =?utf-8?B?ZnFDMGNDdTVidnpxSlNaNnNXdUZYTDJyTWN4M2pWQXMvNDlQa0xRd3V3YUtQ?=
 =?utf-8?B?aVY3Z1BKNXN2ckFsdUZkUmZ5TC94WllrT3U0eGtvUXdXQ2xXaWVqczVqWUVN?=
 =?utf-8?B?d1NXVDNSbUZaVitjd0w0bG5TaWZ4UGdLWTd4Vk8zVWEyOGNvcmpKVCtHazRJ?=
 =?utf-8?B?KzlQZk04SStmcThYV2hMeS9SWFNBTkszLzIwZTJmMUNoOVF1WEFjSlVDS1VT?=
 =?utf-8?B?d1VpVVMvajBZVGZNSGFPb1IxTUoremhvbXk1ZHV2MmlwZ08zNk45THk1SytC?=
 =?utf-8?B?N0JkUjFjOWIwRFJPdXN6OHhuOWxxRUVaRDVFT08wZ290dWI1eS9MV21GTE9G?=
 =?utf-8?B?ZysySndJQlRYZ1JyZWowYkZNMzhvYzhyZXh5VHZoVUsyV1lFZ0VCc1B5eEVi?=
 =?utf-8?B?VkFSVzBYRk1JOVk0cXZETEtSVnFmMnQ5eXR3MHRlQUl6ZzdKN0hIdStNeUk3?=
 =?utf-8?B?aUZaRDJza3h5c2VXUXdRS2x5OWFFSi8reEpFM2dvSSt2WFVqcWc0ZTlnbTJU?=
 =?utf-8?B?VnpyMzRnbHJOUEtuMUpWVS9vT1FkcUR2VE5scVVtNmVZemdlQ3hCRjlJRnVs?=
 =?utf-8?B?SG1pNytHN2NBdkozSk84d1R1RlRWYWxFZlNSTU8rU2FRd3dhUU1FdTl1NFZJ?=
 =?utf-8?B?QVNwMXpSSjBTd3Z2Zmkra0p2L3lpRE4vYnNhK2ZSKzlBREs3WmxjdFdvVnA3?=
 =?utf-8?B?cDRLUk82S0d0d1JqNGZsUFBrYURCWlBXb2tmRWtlSkVOVkhzWVR2MThqT0I0?=
 =?utf-8?B?Zmgxenp2Zk96ZWJibjVRb1Z6blF4M2tLeUx4emR4enBkcmE2OUlOMUt5Yjll?=
 =?utf-8?B?aUJmalc3YmQ0ZzBEak05RktJZVVyelNQbHZTV1NlOVhNTTRNaERjZ1RsWEZz?=
 =?utf-8?B?WFhodE1YSnpya0tlaU03eVc1QktSY2VxbEp3a0dGQTlzUDlCVW0rOHVNczdo?=
 =?utf-8?B?TG9xdTVmODdSejRKTVpWanBrVGt2YkFYTUtsYW0zN1JwbTJtMHREb09BSC9h?=
 =?utf-8?B?Q2lKOFBBeTA5QXl6RUJFRFcyRmdJVnhxRlZkTXhQQU1HbzhSTDVsZ0xMV1Fw?=
 =?utf-8?B?VGpiTDZnTVAzWHdFU2ZOd3pRZWlDMkJUZUpod29odnA2VjBlRnRQemxya2ZN?=
 =?utf-8?B?OHcvUzgzV1MxcTBXVW5yZEZIbGJTZkxCeFRRMjZ1VTJQWmxqdzdoOGp0UHpu?=
 =?utf-8?B?Vk5vMmo1NUZTVEdYNTZoaVRhRG5lWXpsaEc1aExVNFBabnhBbU80SjVjK2Vs?=
 =?utf-8?B?WkNVVEh1N3BNVjE5NVJVamE1SHJXaUxERmZrQU5rNEt4aEwvMFgwMEdmYmt5?=
 =?utf-8?B?dVRmbHA4cmpHUGxGMGQrUXhLV2JNeEFwRXZXZTdaOTVnT2VSL3hnOGFHRmtr?=
 =?utf-8?B?UXBEK3d3T21jWVcyQjZUeUMwY2hzVFYyQWhUd01mY2ovV1JOOFVCWFpyWlNM?=
 =?utf-8?B?VTVoUmRVb1hIaFY2WGVJdXBKQ1pZTzlSRlBNWElBb0lkWDdzbDRlVWpsYkpY?=
 =?utf-8?B?WkZ3bEVyK004ZHFUSVJSSTJlMGk4dHBteERYOHpzdXpab0k5ZEcxeE85ZXRX?=
 =?utf-8?B?L0NiNmd2cjlMUmRYQnRMQmxyRHVaRzV2WnlLZGtKVmlmMGtjY1VuMkRMT0Vs?=
 =?utf-8?B?WWpoYW03NWF2Ujl2d0V5K3U0WWJXVFRwYS96aGYzRGhYSDkxOTRwZmszUHNq?=
 =?utf-8?B?Nm1JaGNJSThNZ1lITC9qRXBiQVUwUFpHTGVzRHhubTlrV0l6bzBialNQZEhq?=
 =?utf-8?B?Ty9TK2xxY3pXazRqVC9LYmZHUkpNVzVNd0RHQU1XZmdxdXdPalBSckpKdnRK?=
 =?utf-8?B?RHd6dkRnVU4rOCtidXQ3Qm82a0p3dU80b0cyRVdXaElQTGFGT0QvZHBHb3No?=
 =?utf-8?B?MkJaUzRLbFR0K1BoL2Nua2tBcGJ4WDdNUmhKdCttdmZCRXdTbXFGV0NvUmth?=
 =?utf-8?B?cjdvUW40eVBOcVB0WXZWU0tpb2VuYlcwRkxEblhabjJNbmM1SnZTSlRycGxp?=
 =?utf-8?B?dkxOT3o1djZvZlJVaFRMWk1YNTNqMnZCNHNFYzhTcDhSejl3Ny9CWCsxc2lk?=
 =?utf-8?Q?FdnnF3oZ0eQynvoXfhkk+vVDJo/co4mTfP5B+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <490A48478671B847871AE30A540D5A71@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	qOH5Z2DqTsEPvkhoCty1OD4I+aW6dpk/y3WoJcTgk3TtIZrV8Z+2n7W6J1i9xLHq8Kp5ocxaRBp/4wG4vdKCIL8sDg22A0Vx89wTwdhoiiB35V0Cu98YFOawNLgnlt6vZ+F5sSCpAQ/Jh0tVfktQ0tyVpamJGQOjn3Vjh6a1IyXgLdOgAlVRAloIYJhs5S+L4GsBr+AXJPvORQeisCrk1F35pOLnSR0TVkXnhkLmwEU/EQ4+A9u3cldVWG0Yg3xflOoCEHTaZvfSvXZHitSE12heZTCpadL28yvT8gtnB0+Lchrh76Bm5u0imNjoZOqTvmmZcMm5PvkUa+PquQ3zbA==
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff707f6-6832-433b-daa8-08debb4f9e01
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2026 17:52:56.0509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnlxOfFlBevg1H3J8g+WUXu83qDRsfvIKSJslTCfuGTkhznzxZQlX1mUFGb/qX5WXOSgFQ6UtCnsUPLnnoeiFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6567
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE1MyBTYWx0ZWRfX2bevmCnhYI1h
 mR2nguItRNRHk2MtvzAa95zpkfZHXDZ0D76HRu9j3OFrq4leOkKXpQLruXxcdiK16KIjzYTTt9N
 TGsQt9zvze/Fh8y2PjgIz6HnrJzyB+GJlEgtoE0FSHW42Z3eq0HdYlWfkfb2T0+SZ46IVzzRqgE
 Ofq1QPQWFIRm9lUNDdY8t7maiVpuxEqLZPFd2FAp65TCU+M61LV/swh2SC9FgZaGuOQdbj3Q84T
 U96o3M25wQVlCOufVyZL4kXxZWWtwReHhOh0DlhhD1d9cSHHi0H6u2m/wiMCMHVTXStQKBANGQ/
 5iGBCkX389xtSx8Ppi4qVts51HIjbkGvefRYj5g9dIg6qQTfLAA0flylVKpzmod5fiQLy+hSOSw
 eAt0ohploWF52AMGDBx2ErLI+4kPhCmQymlt/OOCYL1YzmmBEBUtOXCCLiWQF8Ib4462nDZqdnO
 RrXYKgs4JpA6OeBIeEQ==
X-Authority-Analysis: v=2.4 cv=KItqylFo c=1 sm=1 tr=0 ts=6a15ddfa cx=c_pps
 a=2LRq3VT+JIpsXvqoN2bfxg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=wCmvBT1CAAAA:8
 a=6eZ2M5j-iYI6zCvvCJYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=6z96SAwNL0f8klobD5od:22
X-Proofpoint-ORIG-GUID: FbiotkL1h-iBWJ5XJ8Wtn2A5gnGeZg1L
X-Proofpoint-GUID: FbiotkL1h-iBWJ5XJ8Wtn2A5gnGeZg1L
Subject: Re:  [PATCH 28/34] nilfs2: Convert nilfs_gccache_submit_read_data to
 bh_submit()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_04,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260153

T24gTW9uLCAyMDI2LTA1LTI1IGF0IDE4OjE5ICswMTAwLCBNYXR0aGV3IFdpbGNveCAoT3JhY2xl
KSB3cm90ZToNCj4gQXZvaWQgYW4gZXh0cmEgaW5kaXJlY3QgZnVuY3Rpb24gY2FsbCBieSB1c2lu
ZyBiaF9zdWJtaXQoKSBpbnN0ZWFkIG9mDQo+IHN1Ym1pdF9iaCgpLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogTWF0dGhldyBXaWxjb3ggKE9yYWNsZSkgPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+IENj
OiBsaW51eC1uaWxmc0B2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+ICBmcy9uaWxmczIvZ2Npbm9k
ZS5jIHwgMyArLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9uaWxmczIvZ2Npbm9kZS5jIGIvZnMvbmlsZnMy
L2djaW5vZGUuYw0KPiBpbmRleCA2MmQ0YzFiNzg3ZTkuLmY5NzlkYzlkMDRiOCAxMDA2NDQNCj4g
LS0tIGEvZnMvbmlsZnMyL2djaW5vZGUuYw0KPiArKysgYi9mcy9uaWxmczIvZ2Npbm9kZS5jDQo+
IEBAIC04Myw5ICs4Myw4IEBAIGludCBuaWxmc19nY2NhY2hlX3N1Ym1pdF9yZWFkX2RhdGEoc3Ry
dWN0IGlub2RlICppbm9kZSwgc2VjdG9yX3QgYmxrb2ZmLA0KPiAgCWlmICghYnVmZmVyX21hcHBl
ZChiaCkpDQo+ICAJCXNldF9idWZmZXJfbWFwcGVkKGJoKTsNCj4gIAliaC0+Yl9ibG9ja25yID0g
cGJuOw0KPiAtCWJoLT5iX2VuZF9pbyA9IGVuZF9idWZmZXJfcmVhZF9zeW5jOw0KPiAgCWdldF9i
aChiaCk7DQo+IC0Jc3VibWl0X2JoKFJFUV9PUF9SRUFELCBiaCk7DQo+ICsJYmhfc3VibWl0KGJo
LCBSRVFfT1BfUkVBRCwgYmhfZW5kX3JlYWQpOw0KPiAgCWlmICh2Ym4pDQo+ICAJCWJoLT5iX2Js
b2NrbnIgPSB2Ym47DQo+ICAgb3V0Og0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlh
Y2hlc2xhdiBEdWJleWtvIDxzbGF2YUBkdWJleWtvLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=
