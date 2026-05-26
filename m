Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF10441C319;
	Tue, 26 May 2026 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818020; cv=fail; b=HwGRIYrbe8LzvZn/ttc0YicUJWl2wLocujlWHAuXfF6b+FIybZAUxCvkOnGxha6Hc8J2gJI2fXrxnDDQPbrXrqD3Zl/eQzF9Mwj46HMqhfPU5OoGVbgb4fzc8KdoyD0RJ3DFRqKd2QzEEqGdshrjtxUv+WjEMvwRuBNel41GtHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818020; c=relaxed/simple;
	bh=TNixkdr4nFmB/EAk0oiYt8jJT0BEV888yqsuwCrk7+o=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=pXylhG1R9PppcBIUF6DHJtg1UbrCspN4haM65AM+b7ak6FQej8gfQ+k1OlEMvNOgdqFmTx3t3R2jRH4YsVIWEzLU0blwaFbLtg2dyWMTHp5pVH+2cIpq7uwGeEtqBkyKx4LNU9xgmNHDmQ3uqbMTc83vYTaJrnsvB7hMWt5lwh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IAKoH1RJ; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IAKoH1RJ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QAHKmS1617929;
	Tue, 26 May 2026 17:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=TNixkdr4nFmB/EAk0oiYt8jJT0BEV888yqsuwCrk7+o=; b=IAKoH1RJ
	VW1xTH6fA7L1psRhyNj3pdK8076TZsobElSa7VpZXHIi8BRauEr8B3llOUQW36ou
	ZfF05R0O7emOL0EqFWY1TsXmLpvfccevOVZ2aDyxysi5Cv/kEKxYwc/BmPtAPgiy
	wnCakD4jXpwQh+rPuJVtEl+Cg7qjR5d6oDJr/S5QEDoWZBcy5Z5uKNc+AnOoZUvj
	gmlFPziYtIWHvdOvfSbIl1C8IHJRjX2ly+BYA1v9WZWewvFydKAm1vqdgRyQjhWJ
	B9uvomeeLHoXVUuJFkwe2x98gRSEdHmpLX+GJHW9az7kB1CedrZ1s5NzzxBT1abz
	/o4YYdc+OzPyPQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011020.outbound.protection.outlook.com [52.101.57.20])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4qbwhe6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:53:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpSCTRlGBQI92s+asg2n/uakR3ukLNosNJxLpw0BePcwz0KJuKB5HlTlF8CJUmHuxuobz8au3c270AXns/t0pCSRovsIW148zxs9kdoyFIlf5Bm1CiWSOcPuMzlXC1BBQsHgC7k5+OedqPXYMI/gtP3Ob4l26mldS7EbtnIzvczgOVkKvedi7JxlM6hLYOnggRAwWDertVxkznlcdnZVhDKSMJv6uGgXt7fNX3Sj+kQdW2dcMx1rksS460U9Eo2+8Srzk1jX+EDncaJQ6Oq/skJaniBVzTPz3X2OXZgdw/jATdpH+tjaSXUBnpdp1T5QRjjZdaYf7Xv2MAOYN99u6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNixkdr4nFmB/EAk0oiYt8jJT0BEV888yqsuwCrk7+o=;
 b=HVmP3qfrAyhEo31avE00u7tJe6ND4rPQ9c/brnex3NQK3D06HtA9P2Lsmb5FefOXXH+nkCwz3J+xjYvGuDcHsHPX6MVcgjYilSLW+eYiMp5LSoQPyFdDIQlMPZ3rVHQpSsiS2883eQYSwGTspM3myFcyWkF1MggPYQbX1J5Vxo2eLxqcljh32O6eOBYQfHwAjtPD9k5J1pEHIPECTXTmOYXxkkZQGG7DT9MljJ4e9AK+lKaAHPquGPFlJueOO1n2avEBQ20cB4fkv6T8K/VTDcpaj16Nhlgi9FYrHxmJ9fJRxI455eFxFS/mHo2T+VMhKVzKu2kg42BrUxmHB9Av2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV3PR15MB6567.namprd15.prod.outlook.com (2603:10b6:408:273::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 17:53:27 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 17:53:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "jack@suse.cz" <jack@suse.cz>, "willy@infradead.org" <willy@infradead.org>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "hch@infradead.org"
	<hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 29/34] nilfs2: Convert nilfs_mdt_submit_block
 to bh_submit()
Thread-Index: AQHc7GtsamleQO7inEGNBT0i9CqMILYgmEKA
Date: Tue, 26 May 2026 17:53:26 +0000
Message-ID: <19e4371075163ffa2168cb0ec934da1911e057d7.camel@ibm.com>
References: <20260525171931.4144395-1-willy@infradead.org>
	 <20260525171931.4144395-30-willy@infradead.org>
In-Reply-To: <20260525171931.4144395-30-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV3PR15MB6567:EE_
x-ms-office365-filtering-correlation-id: b6301f29-6ae0-40cf-e36b-08debb4fb006
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|4143699003|11063799006|18002099003|22082099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 3sGvcdeNmDizzKU6v6hfoGevybyj2zqcwWhhx1alJEhyPAIfWYpG4vOkdjxqynW1r4kk10UYd1F8/ZlOA+Y0VwJ5nfnaA2XBSlqxs4z82WM8eb06eyatj6JuiYUjjGMm3eeAn2kQATd+oHAr64R+j7IR1Tzb6XGdDvhqWeH8rfI0jOPKSC82alI8kKjNpSDc49C6RZYjU7/EobCnEcY6NQz+1K4Okgoc5qLYiwj4JXJcye9BZI5N+mBvpV4k3nr3AkNkY2nyF0Zy/VMsolCJ/xVsJqpML/mUVTo0+ccOtemOlBDNbKgIJFpsS3VScN2F6h/mgV9MxJUIiVVhpsntT9bT0JPgcqJrc6BijMTQp3kWz+nawm3+8m4Giv4/U3gv5RtdrqqXvpkK2zJxQRUfZP9Y/7KC3tx8oRyda56fxo6ktG2RVeAprsp1Wxuz1H1Dx5bEf0KR9ukp+Ds6m11oRX8fKY3EX2Me0/2iJ5AwbgxaAqqKTI5f/lQ6H5czP8dS72VKVHoMQKNYGkhWNwUQJXj0z/9Au14CgQjAsXzxJETCpn9eMrEimxLuCsi562O8a6vql/B8Aglk4/8gLxhH62m2dpEXxivqv3t2JrXa2A6waVYZHG+mqdzbP7NG8uPjIMgQJdD1EEZ+AbhusfS+BnhyVpQH1Fc+85wsbeW6hOH+PtWp2i0clJIoVYEitq4NULKSmBisn6sw9cPY06FmsFT3HZ4Ky7iJ/4vBklnkZpduJbrmXiGXtJ2ZVrZXsZ/O
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(4143699003)(11063799006)(18002099003)(22082099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eloxREp5bnB0dG5BRjdvbEdCSTZDVURkTndaYWJ6RThrNERhRzZSaUdaUVlT?=
 =?utf-8?B?QzV6amlPWU9ZOHNjZG15d1ZScHZrUmZxMVRkMm5Mc1Ywc3R3bUJNeXZoTFRH?=
 =?utf-8?B?anllSVZYZENKUkI4ZTNLbkJ0M0xyTHlMVzk4QXVIK2FZV0Nublo4UHI4ZGw1?=
 =?utf-8?B?dGxvWFd4NUwxSG9vY2RqSnBPT09GTVRIZktXejlmQWEvenp2OVVQbk54dlF2?=
 =?utf-8?B?TjhoOHJ2U2lOQkxJN1NBczFKekNYMFlRaDllSnVQTTB4c3dzcVEwYllwVEF2?=
 =?utf-8?B?V1ErOWxZK2pKcGZ6RDNkRWpmMGhWOUR6STdVc3E0Z1NXU0tMdjBBcWdPOHBK?=
 =?utf-8?B?SWZJUmNvSWpDTFRDSU8xSGdtZWhMWXI0SVk4SHRFd3JHZ0lHYnFZNDNuSUJX?=
 =?utf-8?B?Rks4N0JISERBOGo4WXlVN1RONWs0L0hTWXNPRUY4TmEzVXRjaGRwZlFtajhU?=
 =?utf-8?B?RzFabDl6ck9wdlF2RUxFTm01WktZZmdsaGo4Wm9qbm5UaFJkSXZleHpOc1o3?=
 =?utf-8?B?OWhyaDBKSmJ4S3VJMW9GeXl6RjVCa3ZtN2VCZHg0LzhBNXNYV2ovNm5JQmhP?=
 =?utf-8?B?dlU3QVVNMTdoNVFXTzBXb0JyRlh2MmFjL1Qvbll3S0g4YUxVeDVMYzZKUG1k?=
 =?utf-8?B?U29TM29ka2hhdzNTNGg3UUg0Y0ZDTGZiTXE3ZGZCMVptaVo4UVd4Y2hTWWE5?=
 =?utf-8?B?UjN1ZFRYUjg3WDBsZ3puOFBsczdibm5SYlo3MzJzSjZZaU1tOTl5Qnk4UXBw?=
 =?utf-8?B?OWNNNElsbUR0c0pMM05kdmEvR2RJS2g0S0tjakd3UUtHNzlzd0VJMDlpd3Jl?=
 =?utf-8?B?ekZtTGFjYmJRbmowZyttRXU4YlN5UlNVbDVFeDZPaXd3TUZjbHg4dUcyQjdW?=
 =?utf-8?B?MmZ0ejdLa2hIWEs1aGtnTU92cW53WVhVQlg0VlhuUlowaXVxQmtERXIvUXMr?=
 =?utf-8?B?L0hSd25DQjNkY3NhSm9QTXgzTHBXbnJYKzJZa0VlQVkvMjZsOWx4Qis4dmxG?=
 =?utf-8?B?OHl4Q082cFJtN0RBMWlYUEFRNEtNblZ3S3V1ZWl5aHFSV2pVNURwTitCT0p0?=
 =?utf-8?B?NUpXYWVtQTlES0hZMHk2VUF3UHVubEdtekkrVTBNaVo4bXh3cGpkZU1oTlMw?=
 =?utf-8?B?QXlNcGNoenYxRFRaQ2JHbUczY3N3TWlrSWJ5WnVjK04rRkVDYVFTZlFXOFJH?=
 =?utf-8?B?RCtHUHFqYUNRZUF4N0NnTnljMTMyVU5aMElRK3RnRUt6TUlqd2UwK2lkUFhW?=
 =?utf-8?B?NUE3TDh4dWVKNWxDWnFGVjhtaTIxQloxL2hyVUFEWS82bGdkbkFHcVhRY2Fr?=
 =?utf-8?B?Ym9ZbXB1U2Ywbk5IT1U5TEczZTlVOWRrdzByYVFoU0JLelB2T09NUVNsMGFj?=
 =?utf-8?B?SHlKRFVBMlNRUm96NUJYNEdsbU1NQ093dFZqSkNJVHZ5SmNxSVBEWGJmeTZt?=
 =?utf-8?B?ZGE4N2lLQnFmUkJ3VitJWURESlRsR2dyMUs1aFltZG1INDlqTk96Sy84Qmx2?=
 =?utf-8?B?ZUNMM2NpUjJLcVhwSlpLdzJrdiszRHQvSS81ZlpVWlRyZER0RGF0YTErbFpa?=
 =?utf-8?B?SnFDUE1lRnp0TUY0bHEySkpGNFlpT2U5UXE2YjdxM2JyY2hFUmpMYThRUE83?=
 =?utf-8?B?OUY2dnVZRnhHUDhENDhHUDIxYXg5Y3N5S1NtaTBUY1JjejZ0Wlh2RHBwSm1u?=
 =?utf-8?B?anpyWVJ5VXM1ck45c0UzcitvM2Jza1JFNWV5Mi81TFdIcFkyZlFPOHh0SVM4?=
 =?utf-8?B?Z3gvM0lxK2tXSE91MGFhajQ4UjJrNld3K0NMK2Y1dy9JMElDd3lUTHR0NVNr?=
 =?utf-8?B?SlhXeGw1MUp3dFNJcDUzbVJrN2U5RXd4SXV3cmt3b0NDU2x3d01keUF4b1VM?=
 =?utf-8?B?MlBkNHJ1Z2d2NmNtRW1ZR1hTbysrdXcvY1E3NDNRU1dCWGlrT1ZubG9iY0lS?=
 =?utf-8?B?cVIxWHU5c0w4WERJTlJjUEhZZ2h4QXJXREZSQUVVT1hBTTBXUXRidFk3K0ZS?=
 =?utf-8?B?NkpMYm4rM3BQVjBQMXJjdlJRWExuTnJ3TXl5bXRJU1hURStTY1I4WEFsL1dD?=
 =?utf-8?B?ZjU4YnRGZWU2TnZXWENnSjlselNTcCtxaW83ajBQNUtkU21BMk1NZUM1YWlh?=
 =?utf-8?B?T0xLWFJKeWNoU3RFVVNDeEZOTnViNDFtb2xHRkI2MEFhWXlHd1FyT2JwOFhw?=
 =?utf-8?B?dnVZNy8wZVRRR2ZJazMwKzFKUHR4aENMSzVOTitpZGpQWDJlWHkvQXphOERS?=
 =?utf-8?B?TWhWTmwxd0VoVTBWdTR2S25XL2pkbHorVmhjYzJId3ltWEovSHNMdjY0ZFBZ?=
 =?utf-8?B?TU1hcWhOb1pLMnpqVElUTlYydDhNLzcrTitzUFovR3FhN3lzWWhyeW5ZN1Vo?=
 =?utf-8?Q?6vR6UJddEd4Ftr3HxID4e+SyO+XBHvvwSDg2N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27770312965BCE479AA8AA9340955675@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Qwlgfc8omipV7KVUl/eXptkTuQE+uMlSPGHjbD4IOSDKR3YadfZjVRf/7fpmzLSNAuVJeZpH2VaEpPvTHTg1PXn35R75Q7ZKFv+iZv4YZ9kNwbxHY+Ag23FLTBfhlJuycjD/6Tcug9DBiUBSfW69aeowusI5l1Sy0i6B+3G73l+tlO2PxCtsB8KWKh7EEA2q4uHHBKjrt4oKz8hdVYuo/DpSAArCcBz8tPv+YTwRJvmVHryX1adQZOXvYH/PcNt5SFclc75yeDCeDMQ/X+zcZgGDYJvFwrt6Nbb6U7W/k3ANni+5RqsFoColDk5t9fWgmQLJr9tAJPl2Grvpx76Bug==
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6301f29-6ae0-40cf-e36b-08debb4fb006
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2026 17:53:26.2903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B2HjR7a0OIwTbfE9EyYddwA1Ctn3nr5/J887+mVZNCzRVYVglbeEfIl5gUTcZoIrl/zPVzsCsc+SfX3swqWBAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6567
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE1MyBTYWx0ZWRfX+05u7sTK4DZY
 hjDxir1RW0XLuSobjvCgfts0lNBVgAGmIQq9MbaI2H0fH+oaJCsRbWFE14ueuVrJ2oCf3dxESx7
 BAXx1PxrYBrRZU1l4EgSP4nUGFKAqsl5S3fxZ5CJAIk52tgcLaEYmgxvtK3ahjPMZpCAlBFRYDP
 z6pLGCkgYMku05eJsd/rafsJGNQ27hZ2D8Kbo+Hb3YSjcW5Bdt9FZij1VHdJuIaeZEy/ON3m4jQ
 jjU+18FU/8xPN6L97z7M+Ynyw4287Aw19ebgya8kJdPTqrqS3VLpRZudkxoaDAVzMV8AW7YeM/5
 lHmrnSHV/BismEUdEOGlFZUI0ZCU6Bg8i3iBS/9PtXP27cQfSjMlmV5lhUdeV2dkA+2Q93AxbaA
 GzJIda0iU30EkRWzuofZtyb+kV7YgNu08OV5Gwfq78G60KKkSHDEmoHRUabzSitgRsPp52ur9AT
 dwqd8pDydgEH7b2YksA==
X-Authority-Analysis: v=2.4 cv=KItqylFo c=1 sm=1 tr=0 ts=6a15de1a cx=c_pps
 a=pqTWcw9xC4/AVWcamW/T+Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=wCmvBT1CAAAA:8
 a=6eZ2M5j-iYI6zCvvCJYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=6z96SAwNL0f8klobD5od:22
X-Proofpoint-ORIG-GUID: jrytorMtK-aPowWuH5YCTy5XVgJXosIp
X-Proofpoint-GUID: jrytorMtK-aPowWuH5YCTy5XVgJXosIp
Subject: Re:  [PATCH 29/34] nilfs2: Convert nilfs_mdt_submit_block to
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
OiBsaW51eC1uaWxmc0B2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+ICBmcy9uaWxmczIvbWR0LmMg
fCAzICstLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL25pbGZzMi9tZHQuYyBiL2ZzL25pbGZzMi9tZHQuYw0K
PiBpbmRleCAwOWFkYjQwYzY1ZTUuLjI2MDQzZGI2NzdjZCAxMDA2NDQNCj4gLS0tIGEvZnMvbmls
ZnMyL21kdC5jDQo+ICsrKyBiL2ZzL25pbGZzMi9tZHQuYw0KPiBAQCAtMTQ4LDkgKzE0OCw4IEBA
IG5pbGZzX21kdF9zdWJtaXRfYmxvY2soc3RydWN0IGlub2RlICppbm9kZSwgdW5zaWduZWQgbG9u
ZyBibGtvZmYsIGJsa19vcGZfdCBvcGYsDQo+ICAJfQ0KPiAgCW1hcF9iaChiaCwgaW5vZGUtPmlf
c2IsIChzZWN0b3JfdClibGtudW0pOw0KPiAgDQo+IC0JYmgtPmJfZW5kX2lvID0gZW5kX2J1ZmZl
cl9yZWFkX3N5bmM7DQo+ICAJZ2V0X2JoKGJoKTsNCj4gLQlzdWJtaXRfYmgob3BmLCBiaCk7DQo+
ICsJYmhfc3VibWl0KGJoLCBvcGYsIGJoX2VuZF9yZWFkKTsNCj4gIAlyZXQgPSAwOw0KPiAgDQo+
ICAJdHJhY2VfbmlsZnMyX21kdF9zdWJtaXRfYmxvY2soaW5vZGUsIGlub2RlLT5pX2lubywgYmxr
b2ZmLA0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxz
bGF2YUBkdWJleWtvLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=
