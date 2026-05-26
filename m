Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4843413245;
	Tue, 26 May 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779817917; cv=fail; b=NOUdXzImwMsqAEO8DWzbhIYjfBZCaT5apiaL+2nktBPXmO4vs9omDsMwPeC/1RXryG3I0UjOXBOo/Tp1KPAvOQotig1Zekx0MJPoxchoZOOEVYmioqQGaynF7zSZVdmUr17mz4YUcvz1s+pBLC3iZO7o1TC9CinrKB4dLHT+Puk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779817917; c=relaxed/simple;
	bh=sd7DmWZSMPXryPglITnlcA6YzLleVxL7OQKd/8GP8t8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=XZhN1QG7LWMvVKWRR9G1RArpV0nLmLtxC+UQT+sAXgLpeyC/RkN2slm54N+lvNhdg3rxxG/wGpazPSnaHK1oUsr4fmn+/BNlusaonIoma+3Cgx1K2oPlLYTbIYy3L6DsKCc/AyXs69PqSw4dWljj4Gl7BbNNmS4NTStvH9X4d+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Rng05oH9; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Rng05oH9"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q9eFdo3032008;
	Tue, 26 May 2026 17:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=sd7DmWZSMPXryPglITnlcA6YzLleVxL7OQKd/8GP8t8=; b=Rng05oH9
	LbaMZiXhPQ8iRABYrQ7iDOIp3gkIruRpo8YBf7PcF5Bnygzn+ebTExs6riW3kSPA
	4ccBlU6BJ81pmOK1f3XzoU53naXsG8xhabc20qK05pGh6x8i2BcxQHz/xmATBJ1j
	fpNnJXM0qUTobFkLFE9MeugNjajL/AtLhTj4GL/8NgIYBSqaq0Ql9sWo5vE4DS/K
	TCGs6cV0eziUoBvqn9n/85MQQIOa/ps25Ugp+HsiS7rwiCWkGMkycRYTjCkIgy3m
	GVjm1nzI9p9LvdgUEe8PHEQtCj1BdZM1QGow7V2ym6rO7t5BvJy1Nlhe4muk5I+o
	Z3BD2pnP85P/XQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010017.outbound.protection.outlook.com [52.101.193.17])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nc4gqy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 May 2026 17:51:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvSeo24CjApcbpQrxxsAADAuE0VATr8t2S18eTxWU0tojbBHcO4lDPxcsWKuRSyNnUPHx/hNOI7kvABvLPW9khiabzNaCSmXvOblse1G4mzRDSkRcHi0g3Bz6ryAYI6k5ygqT53cc3eQwTk1M3BU2Ai3U/viiEGeE2BIQpnck2n7JDC7+SPOpjlh57n7IgaPG1guko0UtRn9mqiqMbuU6Tq7/7RZ8x2qvlx8Lz3os+06jfqrb7zPLs5VnyV/+/odVnZ6USj5aZjVJX56O9280ETUFx1a8/yEdNo1rMXLiYN1Dn6iixFD+fGpLREuYUhXoEqAAXiVwRqtzOi83T8gQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sd7DmWZSMPXryPglITnlcA6YzLleVxL7OQKd/8GP8t8=;
 b=gUVywJbjpCpb42gbxN0D3QD07Y0j3LoAQz3SBvuSiRlfcSqcKNHCDjYR4Q3Ed4sA121YrWFI7MfDMvLYyLHZ5DGWb2Z7W7wQMALlJbKYg5EtOEZvEAlMezaxjOP6B2Q/4PX5UM97iZ+9V99Yy+plMYtSpBfXunDGTidvLKhdiZyAK9XTaG95eL1ov3cLFvRgr/PA7D34C8GAu/r2SeCifdwkGhgJXIv8mW4EseEWarSJYEtu0aAmmIU4BrgGbo1wRME8jjnRcQ2WGGnX877o7Rnr4FdAFz7QJfPPcNsf6vtLKIb2/W75+kZgI86ICMw2FgCvVP/RKkIlZFUsQqh7Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB4593.namprd15.prod.outlook.com (2603:10b6:806:19c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Tue, 26 May
 2026 17:51:34 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 17:51:34 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "jack@suse.cz" <jack@suse.cz>, "willy@infradead.org" <willy@infradead.org>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "hch@infradead.org"
	<hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 27/34] nilfs2: Convert
 nilfs_btnode_submit_block to bh_submit()
Thread-Index: AQHc7Gs480AkG1nSEUusk1T7n8pgFLYgl7wA
Date: Tue, 26 May 2026 17:51:33 +0000
Message-ID: <e078ab852f15f720e609b3691c1e61bd1eaeccc5.camel@ibm.com>
References: <20260525171931.4144395-1-willy@infradead.org>
	 <20260525171931.4144395-28-willy@infradead.org>
In-Reply-To: <20260525171931.4144395-28-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB4593:EE_
x-ms-office365-filtering-correlation-id: 99130605-76d1-47a5-ab33-08debb4f6d02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|18002099003|22082099003|56012099006|38070700021|4143699003|11063799006;
x-microsoft-antispam-message-info:
 nuLpUhZqdis2mIHSYkbWverdkaaEeFhdHtTOg/qiOuL7ku1ubMHKIS+nEUrnyl3UmPBRIpwt2PCASLLjj9VxfBb/zvQBKKLnA7RHVWpPbX0qEE8/Rqcjv1/3zleJFuvMGRyc/whxm6TybVm5gRpkJKLoTZEwcONo/3dr8Fp28RRcowQ6zvq8oXOt8HZ4FpH0aFtXmvpyVUK+7drzwjKSWXOLptnLS9krIzB0GNGjdUY0HVD/+0yikFEXqaS9ZCKH7FpWQC66BqG2Smdr4uLTEKiJHOC+NBl1Oq1NbeRS4O7xFs6OetuVZh/uKLIF6W/XeAT1XoRDJ+kohtsGiBbXdm5jbT3kZxKq6Kaum/jXmvIeO/feqmjfAE8w/DWfx7hoBPjxNSDNHHSV6MvVhw3UsD3S0ojRJ/NzbYMESXPDbm3l9/xRljoWtB9eh76TbPtfMyU2FxpdQ/8WGiDVbk359IuqTCtdGCWsgTRZzI+MCDRq9V+/cpPDmCERNdNFgZNHIwEttWiqaGG1NBen9BTScTi1wyh45p+6xMt5okrgGFdknXhj0XMDiVHgZNSY3aU7og4FlGmfZjFm5LdB+vdV0hbS+tBligqyA2N2b2BJQOh6C+15JlnYiudn08RdmUv6kkfCZ7atJwJoHeAiGHA+peLh5XU8r5NGY8WL42ra1NSiJSScUQE38MbwFPyLjgwSdPuViwkiiLIz4d5rxoeHHiAHQ49UFwQpoq0LcGNv6xtooZkjlDj8VG459PGHKeLp
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(18002099003)(22082099003)(56012099006)(38070700021)(4143699003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aDRxWWwwaVkvbHFJbDJpMzZkYVRjT3h3SlhqWlFLeitrQUE2SWJXVTZna3RT?=
 =?utf-8?B?enZYT052aW1EcmhMRHJoWDd5bmlTc21OTlErNElGcHlISWlSV1k5WUpOWE56?=
 =?utf-8?B?UzYyN0F0WTMvMWxna2xBdnJCSFdUeG5YWmNKQlZDSWoxWUw2Z0h5QWhwYW9D?=
 =?utf-8?B?VTFSY0NYclRhZFBoZUFWUmFFbUNJU1lPUTJrS0ZsMmFRTVV1ZDVjRGQvL05R?=
 =?utf-8?B?RFd5M1FKS2tUa2Uxc1lTQlc5SUk4c3EyNm9oZVdRUko3S1RKa1kyYUMwNGFZ?=
 =?utf-8?B?TlpFc2Nsbk1TL1BZRWg0c0Fjd0FKblJRVW53eFVueDhvVWxJWkxuQVVUbjRz?=
 =?utf-8?B?ZHh5NUVSeUltakIzTEIyaFo5MFBUK0FCeFJ4cEpRY2c0eVg3bVJFMnRDVm1m?=
 =?utf-8?B?U0pDU3RHMEhlRGQ0cXpHNlg1bG1DQ2d1a0t2eE5TSGJvdERxQ3BWKzlOR1BT?=
 =?utf-8?B?SENpUnhyTkRkRldPRjR4bEtpRWVKakhIL1hLbEUraURhWnlLb3F3c0lJc3F4?=
 =?utf-8?B?ckI1RlcwSWJYWHViQUZ3YWlwTmEza3lieVZZc1FXSHlqQzg5OXBicERrSGdX?=
 =?utf-8?B?UmtVZXZIcnFDdGp0eXRWdndBM2NFK2xoWjVkL3VCNkMrdzNBVkhOT1JmNGVq?=
 =?utf-8?B?bmx1RTZZdDFZQzFZdFB5aFYwMkwrUW1kaU1VUzA4cFZPRE5YQWtrYlR2Z3RG?=
 =?utf-8?B?bXdHMCtLaHE1ZGtqNVVScU9Zd3BJY0YrUmlWc2dST0hNQzQ3VmduVWlXc1Bk?=
 =?utf-8?B?S3ZienZHMW1NeC9sTW1aczNmcXdWUXZDaWFvb0l6aU0rUkdnTk1oZmtzVUNO?=
 =?utf-8?B?Z0tvL0RqMjNhckUvYTc5cHVVK2FTV2Zta2kxL0tvNkJJeEdtclBvQXg1cG5l?=
 =?utf-8?B?bURqUlZFek42eVJDb2lzRmdReGx2ZjZLZG0ydmNDdHBmZkllcTZmYmIwOVll?=
 =?utf-8?B?SURlRGJsVWptTWkzekJWak55WWRxM09CYlc4dmllYWMycVJKb3pnc1ZTZzlY?=
 =?utf-8?B?YnozSjlUR0JMTmFDV1NLby9yN3YrcHlqOS92WElSUHB6TDZocmVXUDlSS1dh?=
 =?utf-8?B?a2hnN1RGSU1wWnhlR0VJYVcvL3QraHl5RVFTbU1meVpBVTBqUlU3QVpDR0tH?=
 =?utf-8?B?cndSbmJFYWl0NmtiMHpwNjlnMGt0ck04dEcwamhPU05aMEQ1ZVpuc1prR0NQ?=
 =?utf-8?B?SGsvNENWSHFYMlNINnNtODlES1IxYnNSQUQ1OUxHQ1FwTWYvV3ZZeFdmbDln?=
 =?utf-8?B?WEZWWFZFZnlPN0NPMzZWditTd1MrRm5oUXZoaFNNeXBIQjdhNFFPL2tsUFRs?=
 =?utf-8?B?TjF3aGZScjRUZDFmSUJUUSthWFFiZ0poYXF3Vk85bHJGVm1IUW1DcTZ0TkF6?=
 =?utf-8?B?ZkZYKzl3UDBYRVh5aERNSG1rOEVpSHZ2Ukx4K25HVm1RSUk3ODkzekF1dE9a?=
 =?utf-8?B?Kzc4dCsvVi9Ha1lCVzFsQ1cxMEt2SkFCOWdLTFUxNXpjcS9RUFFNNVZJT2xG?=
 =?utf-8?B?ZVkxU1FrdFEwK0p5a08rMmZ1VC9OZVkvd1dkQWZ4UTNlSi9uRzNSS1hpYUNJ?=
 =?utf-8?B?eXU1TTZBcjNNbDlnNXNuQUhhb0t4d1lSc2xtVDNHYUc3RWdjUlhsKzFxK2tl?=
 =?utf-8?B?LzVVRXlVSmVCbGdWSUkrdGVrZ2kzUmprSGRWZXdBVGpEMDdjRDhyYzVoeW9o?=
 =?utf-8?B?NEF4azU1SVQxOEV0aGFCR3dxQlJ4QUZGQ1BaVENsN0d1Z1BpbWZNbXlZUngr?=
 =?utf-8?B?bGE1RzZOeW9NVWxZek5LZXhrNEVnUHcwMEhNNnJmTC9DYXlhSHRWVXRDTjMw?=
 =?utf-8?B?M1p6TkRHaStxcGNBSFRSRm1iZE1aQnVISHpZWUg4a3FqZVBSUU11ZStBdWZ5?=
 =?utf-8?B?dlBzZDNmYktFRWg2U0s4N3FPR3JHNXdpTTA2TU9qTHFIemF3VmdBeWs2NU5s?=
 =?utf-8?B?OUpseE91dDN4a3pUQVZVc2x4TUkxTVA0d253ZWtTK2Qxd2ZHR05TUGhvMzJT?=
 =?utf-8?B?MURKWGRlWG05SW1vOVhZUDNYcFFrbW1paGYxWVNiWWY5ZVhCOUtBcVZBNHRu?=
 =?utf-8?B?TTY2OExYeXN3SGYxTWJ4eGtPbE9iSkhlOWJOK0NpalZlT2ZzTTlCSTUxeS85?=
 =?utf-8?B?Z05hNXoxRXgxbGNmN0lrbFQ2b3VSVFJ5dzFDK3dMYk9WUWswZ09HV3FMQmFm?=
 =?utf-8?B?TkJudlNQbCtxcDNVcmppZG9qNlEwVGdrY0ZCcjVwbXBJb0pEN25wOHRqTHNB?=
 =?utf-8?B?YWZub293YW16NXNaSUJFRGh0anowL3UxbVhWSzgvNU1xNjF2bkJJdmFyOUdK?=
 =?utf-8?B?SmlHNnd2endEUENNY1JuMkZpSXZkQlgxdE8yMnJ1NTQ1TUJNamNDbWt3S0xh?=
 =?utf-8?Q?ubbrkua1W25L0MdWk0DgQBO+vnUybNF6vCbHo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEAE281AC89FF94AB7E825B168193588@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	tC52tSA8cyhbVcKEpLx6bsbSHjupJo/yDWbBTRaQJ5nMsb2zs6enSPnSF+5f0o5kufFgEhiYBUyOJfqEbVj4HZhlhe3DbuiFXrlKRmbGtCVqhl05v5yppm4ErwGTPCmdDDk4AjA21IBlkYasyZk7Ogadr31Sx6Y4GHC4hlsKREreemwHjKPUTN9HH7NXiwA+tiEDNKdeZbdk6LpzYzR2cjvixxuvnrnjbD0W/DCodpkuOSC47hMk0wmvxQ0AvVkbXbI7G7Qji19ZVfuL8xSGV3c8xKSFO/JLg4U52DW7v/asMlW45T3Lex59KE8VJlzVsr65fIRIdWSM+COt1qg3bw==
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99130605-76d1-47a5-ab33-08debb4f6d02
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2026 17:51:33.8659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d3EPs+e+vwaJewYBeJAGE+8xhqmtGArWbwQiRQ9XqDMBpJCDBgemQlqK2aotByr/tKwGAdr4UTpSuNEy7SVySA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4593
X-Authority-Analysis: v=2.4 cv=VvYTxe2n c=1 sm=1 tr=0 ts=6a15dda9 cx=c_pps
 a=ZlG836pX3zBvGR9gn4UHEQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=wCmvBT1CAAAA:8
 a=SGsk9EF5dZxvQdXcexAA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=6z96SAwNL0f8klobD5od:22
X-Proofpoint-ORIG-GUID: aQSAEewdzE-ETNkwy-1KvfJQl2_SLQnu
X-Proofpoint-GUID: aQSAEewdzE-ETNkwy-1KvfJQl2_SLQnu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDE1MyBTYWx0ZWRfX9ZkyvLXFY4Po
 oNgOAyDdp8K9lMF+x/dHh7ZqRSabYFVvn9ZIq8XcKknASTGUBlYgSqKpzhvJoMDV938zAujGIvj
 c46Z6KDvRiCjAE+afUPRKxSkYX72vA/sOloe8GA+xPc5mNz1TZYT1T6OL4+Fp+YWBMLUCOFyrxd
 r/iIKLYTAj1EfKRaI11j0HnU4EM4pQya6zK0DoC3ikqeLA4ux53rQI2jAG9nveaS3+rxQ7nTymP
 4tuRu8FOgt5TPewWSCFRYfyvqLtpwIPTl3bemM71sFUAsQLNATarHEHXamrRO/jKv5C5h41kuAz
 kBRoyCzqk+33BWybxRJdogXddXM1ReMNU9TZ2dM2rq6wv+kxuZZntfMq3639x819QchYy5zerES
 4x76wBJ+nAY1NJdrIJTjhCpvwqmAvuq1JhoXqTIzdxuw3ShoPYkSUs3FTaJy+N32I8GCch+RMkW
 8qTwRi+4wOWDFqCrbVQ==
Subject: Re:  [PATCH 27/34] nilfs2: Convert nilfs_btnode_submit_block to
 bh_submit()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_04,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260153

T24gTW9uLCAyMDI2LTA1LTI1IGF0IDE4OjE5ICswMTAwLCBNYXR0aGV3IFdpbGNveCAoT3JhY2xl
KSB3cm90ZToNCj4gQXZvaWQgYW4gZXh0cmEgaW5kaXJlY3QgZnVuY3Rpb24gY2FsbCBieSB1c2lu
ZyBiaF9zdWJtaXQoKSBpbnN0ZWFkIG9mDQo+IHN1Ym1pdF9iaCgpLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogTWF0dGhldyBXaWxjb3ggKE9yYWNsZSkgPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+IENj
OiBsaW51eC1uaWxmc0B2Z2VyLmtlcm5lbC5vcmcNCj4gLS0tDQo+ICBmcy9uaWxmczIvYnRub2Rl
LmMgfCAzICstLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL25pbGZzMi9idG5vZGUuYyBiL2ZzL25pbGZzMi9i
dG5vZGUuYw0KPiBpbmRleCAyZTU1M2Q2OThkMGYuLjBhNGI2MTQ5OGVmZiAxMDA2NDQNCj4gLS0t
IGEvZnMvbmlsZnMyL2J0bm9kZS5jDQo+ICsrKyBiL2ZzL25pbGZzMi9idG5vZGUuYw0KPiBAQCAt
MTM0LDkgKzEzNCw4IEBAIGludCBuaWxmc19idG5vZGVfc3VibWl0X2Jsb2NrKHN0cnVjdCBhZGRy
ZXNzX3NwYWNlICpidG5jLCBfX3U2NCBibG9ja25yLA0KPiAgCX0NCj4gIAlzZXRfYnVmZmVyX21h
cHBlZChiaCk7DQo+ICAJYmgtPmJfYmxvY2tuciA9IHBibG9ja25yOyAvKiBzZXQgYmxvY2sgYWRk
cmVzcyBmb3IgcmVhZCAqLw0KPiAtCWJoLT5iX2VuZF9pbyA9IGVuZF9idWZmZXJfcmVhZF9zeW5j
Ow0KPiAgCWdldF9iaChiaCk7DQo+IC0Jc3VibWl0X2JoKG9wZiwgYmgpOw0KPiArCWJoX3N1Ym1p
dChiaCwgb3BmLCBiaF9lbmRfcmVhZCk7DQo+ICAJYmgtPmJfYmxvY2tuciA9IGJsb2NrbnI7IC8q
IHNldCBiYWNrIHRvIHRoZSBnaXZlbiBibG9jayBhZGRyZXNzICovDQo+ICAJKnN1Ym1pdF9wdHIg
PSBwYmxvY2tucjsNCj4gIAllcnIgPSAwOw0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTog
VmlhY2hlc2xhdiBEdWJleWtvIDxzbGF2YUBkdWJleWtvLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEu
DQo=
