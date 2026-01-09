Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004CB137923
	for <linux-nilfs@vger.kernel.org>; Fri,  9 Jan 2026 00:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767918735; cv=fail; b=t3HVHDxIFmzPPHZjkGtgBTPlBD6kCjwFWzZN0lliqcBQ6ppy+amNvWyGDwFyXANKg9x4AZZP7JPrQbFmWJBATHzIjFLQnyxn1Y+re1qUxb+/NJdJV/1suG4B33cTheUlrO6sJRFe9KSpEB6cG+6dwO3K9wzd7FBIvrrmiZFPKiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767918735; c=relaxed/simple;
	bh=XFkovqi2eYUzUKQXj5PM3ZzThd0loe1Lyq3vZ2LsFaM=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=UlmukfKsU06Noy+GrGWHQ10aBHyuXgkKmGxkVtYjEn4aJ9pP48vvbuPpy9p6pNhqEt8KFVBn+8zU+n73kO9ZGeSuR4UIXG444bsX6JoPjbOLw6X95W8jSPeOu4sjpsWTPbYtBWtMG0ILyFeQJiyp0F9qqhBninOBNgaMSoShRyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rpqTE7uw; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rpqTE7uw"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608DeqZ3008531
	for <linux-nilfs@vger.kernel.org>; Fri, 9 Jan 2026 00:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=49mp8XA6QVsIwSy32iHf1y2xOHIWWBNjbMs8q+J4U8g=; b=rpqTE7uw
	RC0XXniLcgVpjxHdsb1t64piOIRoo9ZScer+lzn2dAxaqOc/OYvbHU8rgCcotBHX
	g3jf53GYCS31opRCP/6rYBsWaWR5iQ3+QTu/KyCISf7WD1l0PZmrI3igXozwc45J
	OgtgFZ6b6IPH7RpXcJnIDSZNlcvVGxobsgkiMai5eboqoXuLVs4RrUdALSVK5WrE
	W0sYVicxGburLc7z6CC/QXEt4QmCkzFh+SnaMTcYHp3nF5+o5cKSJGFL4FHHidJJ
	H6TkgLS8VKOjLDk0Jjh+BbRYMX/OuKTOQwOTkN3/qM9LSGq1bSdxogxQeuWMByod
	2qxu+BZNc0m/cw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm7h02c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-nilfs@vger.kernel.org>; Fri, 09 Jan 2026 00:32:13 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 6090WCgn001736;
	Fri, 9 Jan 2026 00:32:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm7h029-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 00:32:12 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 6090WCaj001726;
	Fri, 9 Jan 2026 00:32:12 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010013.outbound.protection.outlook.com [52.101.56.13])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm7h026-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 00:32:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vDmRdnNsRnkcLblButd9jwjVTtxgdebkwDlZesQR19GOCM7iF+JYLnFMZvqjjExLsJtAIpbUKpktRhXWzaqGkz9kyvLwWgUvp4NH5xTqwfJfXjhwgXCx3jEhqvhZgLebg7xRkNrebXJ4ChNvfY5uILrmYhhQNrF7mIXDLxvz4iv0REvq7zya5HuprNwO5rD1vrB9SAGO3plYcYxFySbD7nwEKH8KLWq04l0Q/eD68Bh7S29vEElbP+sUP5bbm+dGxBH/7UOrtGCZRhPEV7iakzuyWxPlNRlGF9aMGg1WrNmnADTAt3VHj/H1NYRaIKlT3JQXgixYMNySuHYq/fdpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vLA8Jx5O73MR6s6miyKFmL2DyGkTNU6ZAwvwvDGuMc=;
 b=EOBK3H7o27ZjBqd6QtZQv4WUa6nOc71NzHJRUjQmZPWUYZGUi6SqA3j0n3EMo2TEIcPxaP9R0Cu1mbWjd1Idpa4043+vo90lPXQd0PZQdGjpS77tzzSSCQtPvN9gBSAR03g2YWITuR4BMhwtlLU5/OJuA5zHRr8UxgZiqAoor9K6ZgqvzRvZP/gBXWZT85VAaReR4PSdHjlFxREVAV3yGabN5cicL9nGlwalgT2od8BSuxK0OH6k2i2TySVhT6yX0rV4HQ3s5lpeKbaa8woIU+dGvdWLxEPew8dIH69kKt0tqeD2rXK6PqV52zVjECOoeOMqMi+PVOOGhglBZ7ptRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SN7PR15MB5729.namprd15.prod.outlook.com (2603:10b6:806:34e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 00:32:08 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 00:32:08 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
Thread-Topic: [EXTERNAL] Re: [RFC] generic/003 xfstests failure details
Thread-Index: AQHcgFPOFYKtpyPNIku2OF7ix7+eSrVHw7kAgAE6ZIA=
Date: Fri, 9 Jan 2026 00:32:08 +0000
Message-ID: <d7bb64793d0990cc4b441c7a55e30b87b13dd4aa.camel@ibm.com>
References: <93c5c0a639a31958876739641fae9989afe8bb26.camel@ibm.com>
	 <CAKFNMo=a+gB+SUhWGO+J_2t7TOgzfwYBsJLF61UGEfWej-yLrA@mail.gmail.com>
In-Reply-To:
 <CAKFNMo=a+gB+SUhWGO+J_2t7TOgzfwYBsJLF61UGEfWej-yLrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SN7PR15MB5729:EE_
x-ms-office365-filtering-correlation-id: 4b4d1936-4378-4d6e-6c57-08de4f1685cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QS9CUlB2UHRwa0RvK2NGWDRmSE03eTlkS3lCT2hjaC9KS2I4ajgwNjdmdS9r?=
 =?utf-8?B?NnBmYXh5SFpyM2ljWWZDeElWOERYSGZPOUltS09wYzFWZDVxdHBsQTB5OVBp?=
 =?utf-8?B?QzJyRFVCTSsxcXVmRVc0djNmNE10S0V5N2JMQitKSGJjTE1KOHBpbTB4MGlB?=
 =?utf-8?B?VzNPWVRFaUdXTElIOWZkZ3ExaGlSVVErM2ZPMk4zQ0RPbStQdHIzQXZMSUtC?=
 =?utf-8?B?ZEFEUzJYY2JFU3IwTW5oVzFTc0R5anZxNkVPUmhaMi8wMU95YXFPcThxU3Z5?=
 =?utf-8?B?djVaZ1p3M3dldmtiN0pvYkdneElxYWc1THNSa3NGQUxLVEs4eFNZS3Q4NVZM?=
 =?utf-8?B?YkYwNTZiSFYvV1ZybXd5Qk4wdlFoWmZaZzRnc1piUktIQi9LRlJzeG9FMHFh?=
 =?utf-8?B?NlMrYXk0Ky95czJJSHdPUDc4cnR1V2kwRVFCWVh3T1Fyd3luU0o4bFFQOGNl?=
 =?utf-8?B?YnFTdzNLRzVWaUc1R3poZHFNSmRXVVRQdjV6SW40L3M0dlJrcVhRcHJIOGUw?=
 =?utf-8?B?bGNaSHplczB5TnMrdVo0bVRZTVp3L0N6RXJIM0VpaUdBbmVKVnVSdGljVC9G?=
 =?utf-8?B?djFSa21ldXhpcmxtVzBlV0R2eXFWcGExdHo5U3lFbzRYZnpvcWxwTnE5R2Z2?=
 =?utf-8?B?N2FyK3I0ZUxJSDRNL1JkRjErMzVWU2dIRk9MbEJ2bnBYSytUVnk3NEoyNzIr?=
 =?utf-8?B?SjNNQWFVNXV4NEYxWHQxWWxqUWxyRFpaeEg2K1VFcjFrOUZOcDZRbXAxTm1i?=
 =?utf-8?B?dURoUmZ5SnlEaWQ0Y0V4QkVCUS95M2t6SENFa3hiWWVlRUNiV1Q4SlF4QTls?=
 =?utf-8?B?QmpHUTMveWlCWjlXTDF4cnJPWHFVQW1ROW5KSjRlNVE4T1RtWDRpYkd4QmJl?=
 =?utf-8?B?YlVtZVNqYTRWYTc0T0ZUcGNJa2Nla0tyT1Z1dE5vc2ExbENsbXdMWjIrdHZL?=
 =?utf-8?B?cFNqSVZEUWNkamFBOUpSNFlxQjUrSzNQS2xrRjNoZlM2UllOdXkyTVRWM1FY?=
 =?utf-8?B?U0xzQ1pQSkM1QTllZExQbGRiTlR4b0l4akIxeUJUd3U1ZjJnU3FIcTZNUVph?=
 =?utf-8?B?UVdEZTVwQXFGRnBxazZubGt1OG5IVlRWMHU0NG5GaWpUSFRxZDZCdlIyWFRW?=
 =?utf-8?B?bWkySm05dnNjakV5cVI4Vkc3QytNMjVHNW1tSWNWejVJVW5ITFpUais2b0pQ?=
 =?utf-8?B?b0NOTWVFWTJ5R0pXcGgzNkdqcnRhMk03TmlJU2JXb2pURnJSaVpPMkxHUTZQ?=
 =?utf-8?B?QTdlaEl1cE9mNW9MVU1sUWR0dkh4Q3ZHakJiSTE2aUIzWWJ0cE1YallhNkNy?=
 =?utf-8?B?cEp5cE1XcUdPQkdtVEwzQ1Zyb3luT0VsMFBYSkRLNlFoTEVKeWtqL2h4TmZG?=
 =?utf-8?B?a0hJR3Z0SzczSTdmU3JEUENtY1FONEl5WlVCd1ArZncycWtyS3cvSFV4U0c4?=
 =?utf-8?B?amNLQngvRmFjMGRuMUxmWUMxeEZacUdWUWRvQTVwVFhmMVlSWGZjL1M4REQ0?=
 =?utf-8?B?Nk5WK05lbDRPa013OERzbWZ1azkvQmdBY0J4SS9jLzhPbEZzTFRmRmNScUk1?=
 =?utf-8?B?ZDEwdXE5WHo0MEpQL3paWkZLWERBdTFSQllCQzdWbDlmY3dzczA0dFgrUVRi?=
 =?utf-8?B?emFmdmhGRy9FeTlYUCtJVkE5cHIrWDhtZFNodzVyY3c5bkpYQTFRTGN3OEU2?=
 =?utf-8?B?Ujcyd21jVlBPSCtnWHE4QVNONmVha0hqMW1HSkk2WTl2MEtzUzlOZUFqb3Z0?=
 =?utf-8?B?cHhDT3BjQXFZRS9TRTFiSndzTitlQ3VvV3hPd1RlampOU3U5eXZqMzlxMHZs?=
 =?utf-8?B?aTJzUEF5N0RvQjJ5bEZKQkdSekNEU0NKeVN3REpHM2dNeHFqRDNxL2tKb2Y1?=
 =?utf-8?B?RllOeVNIZ1A1UlF5cUxiZVRIdUN1b3ViZExjaTFnWlJLeGdHYzRWL1ZTY1Nz?=
 =?utf-8?B?ZXBTQnZabUcrY0dwV2l5Qkh4VEVBRWFhTmdwaHN4ZXZWVWduTGF4VERMTVh0?=
 =?utf-8?B?U0hoS29lOEtRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RDN4SUkranliMTV3TGhLQWJ1OEY2eVE0MUlpRDNpMWpMOHk3UVJYWXNwM3lC?=
 =?utf-8?B?MytuWjVlUXhCNWZRR0lhWEFDRnlud1VUNkRmMzQvUHZ5RzgvdWxZSWZ6Myto?=
 =?utf-8?B?Z2pWOVhReExuMUlRUE9HeGZtYnlEaUlSVmsrU1I4TTZJNGVWS0pFcHBTSDBV?=
 =?utf-8?B?RTlaTllyVE1LbENmaXFTejE4d0NFdUorMFE4c05qT3BUWWNmRTFXeDNXVU9Z?=
 =?utf-8?B?YloxZmJQbnl6SjRNYThXc1UvY3ZLZUJkL3F6NGtDWDJVVnpjZHpYUEM5RFFS?=
 =?utf-8?B?dWtaSFZIWko4RDVaMzkyV0V4Z3o4b3FVNExsYWJSc3QwRkRQallJOUFkMmtC?=
 =?utf-8?B?WEovaTJPMWNkVDVVNzhTckJIellwQ3VxcVAvbk5paS9reHlsN1k4cU12T3Rm?=
 =?utf-8?B?OHNMZmR0blNyY1hKQjN1VVMyZWdmckNqd2MxUkhYcVBFWE4xWkk4VDgyYzY3?=
 =?utf-8?B?ME0vaDA2c0VOOGJFRWRJRW5nM0FYU1g0RU9BM1NLRE1qbG1xZllleTZEY0Uz?=
 =?utf-8?B?dlNZcEUyZ1VjV1g2aEhBMkVKNjNPQUFuRXZwUGkyQ0duVG9WcFBGUUZMeWV0?=
 =?utf-8?B?R3JlQWU2bjBZSDNUaURPWVFTNitBc1R0LzJBaHdZbHRRR0Q2NlJhU0dwUmJK?=
 =?utf-8?B?Sk5nRHNoeDVzUmlmQ1cwT3NFSVFKZi9rMVlSSW8zU2UvVkF5ZEhEckZYbFpV?=
 =?utf-8?B?N09FbUJHOVVQUUkzbDZDZU5udkhBOGhYQkpuMXhjQWxtM0QyQk5ySDZrNkRG?=
 =?utf-8?B?dXo3eG93OTZxMmF4czdWSXhDYWNQTjhOTWdva29vVURNaS96aXhYN1pVWHdx?=
 =?utf-8?B?cndvdnVxK2swTHF5QzdSTFFRQWg4dDBMblo3RGROSFRCR2tFdnNheVlOTHlF?=
 =?utf-8?B?TnppUnYxZVpYZmJyOERWTmNlUjBadHcraVJ1YjFWUW5qRGhjZ0RjMFlzaFJj?=
 =?utf-8?B?SzVTQTFLWjJoYXcxb3BLcVc2YjcxSFFKWXU3QW9VazN3a0pqdFFVV0E1bEo1?=
 =?utf-8?B?VEFMakRZUnI5VG1pRXhUNjlLcFBoTUtQNmdTdGJwT1hqM2xvbHd5Vnl6a0x1?=
 =?utf-8?B?SGIycjZlSXprNUhIZUJKbkpibmFsTms3Q2l1U2JrZXR2ZHpPM0JqWWNsRlJG?=
 =?utf-8?B?clFkOTNraGFqdjkrdXE5b1FzRHhVVUxSaWlqaDlaTkFhVmhRNjBIOGFrMjR0?=
 =?utf-8?B?Y2FuUmcrd2dlUEl3R1pIbXIwcE11aWtoYmFsYmRHNWN1dTU0bGI2VnIzODlU?=
 =?utf-8?B?ai9rNU5BSzVJN3lVZVUrN25jSE9URFRjaE43V1JzMjh0aGhFdDdOSHQ1V2V5?=
 =?utf-8?B?L3ZIVkhnemxQRGE5M0lZMkRTc0RmU2d2STlVUXg0c3lzM3NQVHdjS010aTFK?=
 =?utf-8?B?OGtNdkkzRlN1Q3BTcTFad3dtVWNTbm1pazRSeGtlOWhZcjVnS3RxRHFUc20z?=
 =?utf-8?B?dTR3QUxnR0ltQ2xzSXRXTDlUYmlkekRnSXNYblNQUEVIOEROOURJYldycHJu?=
 =?utf-8?B?RXQxNXYrdkhBK2FiU2MwVjA1TTRiOC9Wd21yMjNxam52NEdJRWJuM3RaVGx1?=
 =?utf-8?B?aW5iWlR1aU41YVhQVldBSDFhcmhrdFdZVEhISERlbTZ3R0dzNEFHaVoyVUhP?=
 =?utf-8?B?SzRNUVl4V3IyMlU4Vmw1T0YxeE9GclZ3azdTZDJ5Ky9LZ0hIajk3ZVo5WXJ6?=
 =?utf-8?B?bXlMQXRUY1QxUGNRVjg1UkhmT2ZxR0gzQzcwZXRneUpoTktRVHBUQlptaER6?=
 =?utf-8?B?TEhaQnhXbU5mTnZEa2w5OGF1WTF4VFM5SHJMODJld2ZORmdwUlRvUFZnV0dp?=
 =?utf-8?B?YzVCSUdBNXZNODhiOXpkZlVWa2c1T2EwRHhZYVI2aUh5TGJMN1dZTHlvZWJn?=
 =?utf-8?B?TEk3ZUUxM3lNNTdLN0ZwYTMzcnRENDArOFNvdVZzOVBmRkF2cm1BQ3VoTG5q?=
 =?utf-8?B?Z0FTN2JXUTRXcEt3clJjYUxHY0wxTyt5Z1lCdHNYSDQvODF5bkNROVIyYjBI?=
 =?utf-8?B?eUJSQ1RpbXpkYlRFKzhERVZucHRIR1FxVUZSY0lPdVh6L1JxSlpzUmx3S1Q4?=
 =?utf-8?B?Y1BvWE1DT2hyOUFrZ2VJZkVKK1lRTnVxUUtOdEtoTmtFSm4xK1I4QVFwWmFQ?=
 =?utf-8?B?WFREWlpBSUxWZUZaLzd4UWtqVmtCQnkzZUNJREV6dHh6RTJ6bDJGU2pCVUc3?=
 =?utf-8?B?RGQxZ1FOODh2QytTNXRSaFBGeC9wSzdjVkRxemh4enl0bXc1MXlXUXlDYzNQ?=
 =?utf-8?B?OFRseDdwL1VLMmVYOUt3MjdXOGdYc1dVdFlUY01hRUNWYndiMW9KZ2VpTHdt?=
 =?utf-8?B?OGlBdnJqdVdHQzVNUTNxM0ZtWWQrRXR0Z09laVN0YXNuV1JsVHlPRkFPeHAy?=
 =?utf-8?Q?Hl9+9++zfejvWwS5cGXcY1RhKQOJQRKv8Z7Es?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4d1936-4378-4d6e-6c57-08de4f1685cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 00:32:08.5296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptUsLYyQZ2yrp9B2auoNr1mDmKjT58QHtH3wyzhHD7fsrrrRR+t9EWhF7Ju3Ri45/xJazU1cfp31gE4d255DJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB5729
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=69604c8c cx=c_pps
 a=dfvQMip10+6xT43tUf6YKQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=P-IC7800AAAA:8
 a=GoKX9h5xxKbTChvUYegA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-GUID: bTNboVanHqMOOBUGSIGKhjIT-GAKtdl5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDAwMSBTYWx0ZWRfX7HZVD8MJ+olu
 uo0QyoGBXJThjoQOzOIs67YS7bGM/1RNtzJ6uGkqW4R/TiFU1Waaa2ka5PTDCE6wcjfW6T8NGQN
 owBwbtDMJvfjsqsfiofFQGooBSZAOnhkxyvusEPHd5e627kbbQNlyNqkvjFs+6eEs7oM8eyemHN
 nhbXN0h+9EYAI/Yv+3WtzMFfjzMZ89xwU4Z4DMcNb4pKaxMh6R5Q9JekadK5ls9/kuhX5wLY5gn
 nr0GUf4CsKLDM+yVkPT44LxH0VZeT6WCPwlFFtD5hgQ8/C/XbqRR0PkcNaCGRo4ZykbGMqj+mrD
 pqfxmari0pYriaUoyU84iGLkvQv/8vcqFBqRSSPjrC0l/4X3zqXwasqc0hSSkfNhdFRRLqBpSb/
 xVXVYMl9fIDHDpGY953yY6GxiSVBZsApYyZNV9PG3EytLLzq7PY4sb+VQTjQDkGreJH/AF0O9PS
 LtQ6SkMoWcFGJpbC3ig==
X-Proofpoint-ORIG-GUID: tulL9kMSMztyvekdrFF2iDfrOI4P42oA
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3448ACFEF4C2041962AE0E2BFC35987@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: [RFC] generic/003 xfstests failure details
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_05,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=2 engine=8.19.0-2512120000
 definitions=main-2601090001

On Thu, 2026-01-08 at 14:46 +0900, Ryusuke Konishi wrote:
> On Thu, Jan 8, 2026 at 1:04=E2=80=AFPM Viacheslav Dubeyko wrote:
> >=20
> > Hi Ryusuke,
> >=20
> > As far as I can see, this test is trying to check the access time (atim=
e) after
> > every touch. And it expects to see the difference between atime and cti=
me. But
> > it cannot see the difference:
> >=20
> > sudo touch ./001.txt
> > sudo stat ./001.txt
> >   File: ./001.txt
> >   Size: 0               Blocks: 0          IO Block: 4096   regular emp=
ty file
> > Device: 7,50    Inode: 12          Links: 1
> > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2026-01-06 16:23:18.315637313 -0800
> > Modify: 2026-01-06 16:23:18.315637313 -0800
> > Change: 2026-01-06 16:23:18.315637313 -0800
> >  Birth: -
> >=20
> > sudo touch ./001.txt
> > sudo stat ./001.txt
> >   File: ./001.txt
> >   Size: 0               Blocks: 0          IO Block: 4096   regular emp=
ty file
> > Device: 7,50    Inode: 12          Links: 1
> > Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> > Access: 2026-01-06 16:23:44.535933843 -0800
> > Modify: 2026-01-06 16:23:44.535933843 -0800
> > Change: 2026-01-06 16:23:44.535933843 -0800
> >  Birth: -
> >=20
> > Moreover, NILFS2 hasn't atime support in on-disk layout [1]:
> >=20
> > struct nilfs_inode {
> >         __le64  i_blocks;
> >         __le64  i_size;
> >         __le64  i_ctime;
> >         __le64  i_mtime;
> >         __le32  i_ctime_nsec;
> >         __le32  i_mtime_nsec;
> >         __le32  i_uid;
> >         __le32  i_gid;
> >         __le16  i_mode;
> >         __le16  i_links_count;
> >         __le32  i_flags;
> >         __le64  i_bmap[NILFS_INODE_BMAP_SIZE];
> > #define i_device_code   i_bmap[0]
> >         __le64  i_xattr;
> >         __le32  i_generation;
> >         __le32  i_pad;
> > };
> >=20
> > Current implementation does such trick [2]:
> >=20
> > int nilfs_read_inode_common(struct inode *inode,
> >                             struct nilfs_inode *raw_inode)
> > {
> > <skipped>
> >         inode_set_atime(inode, le64_to_cpu(raw_inode->i_mtime),
> >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> >         inode_set_ctime(inode, le64_to_cpu(raw_inode->i_ctime),
> >                         le32_to_cpu(raw_inode->i_ctime_nsec));
> >         inode_set_mtime(inode, le64_to_cpu(raw_inode->i_mtime),
> >                         le32_to_cpu(raw_inode->i_mtime_nsec));
> > <skipped>
> > }
> >=20
> > I think we can use i_xattr and i_pad fields of struct nilfs_inode to im=
plement
> > atime support. NILFS2 hasn't xattrs support and, anyway, i_xattr is not=
 enough
> > to implement this support.
> >=20
> > What do you think?
>=20
> What do you think is the appropriate goal for atime support?
>=20
> The Linux kernel has multiple support levels for atime, including
> lazytime, relatime, noatime, and nodiratime.
> For an append-only filesystem like nilfs2, supporting strict atime
> would likely result in a disk-full error due to inode writes.
>=20

The lazytime, relatime, noatime, and nodiratime are mount options and it is=
 up
to end-user which particular mount option(s) should be used. Frankly speaki=
ng, I
don't see the problem with any atime support for the case of append-only
filesystem. Because, GC subsystem should guarantee proper fraction of segme=
nts
cleaning operations. It's another point how significant will be the write
amplification for relatime mount option, for example. But users of LFS file
systems usually know which atime related options should be used for their
workloads.

> Therefore, regardless of the implementation method, some kind of
> constraint must be imposed.
>=20
> Personally, I think the limit is two options: noatime, relatime, or
> three options, including lazytime (where inode writes occur when
> evictions occur).

I believe it's up to end-users which mounts option they would like to use. =
But
we need to support atime mechanism, anyway.

>=20
> What level of atime support is required for this test and other tests?
> (Is it simply a matter of decision?)

As far as I know, it is possible to select any mount options. But I am using
default ones.

>=20
> Regarding the atime implementation, it was originally intended to be
> stored in a separate metadata file called the atime file.  Because of
> its limited fields, it is a trade-off with xattr support.
> A decision must be made to either move it to another metadata file or
> expand the inode size.
>=20
> Regarding this, I agree with you that it would be better to ignore
> past assumptions, assign the remaining fields (i_xattr, i_pad) to
> atime, and implement xattr so that the sweet spot of the xattr size
> fits inline, by expanding the inode size to 256 bytes.

I selected the i_xattr, i_pad fields because they can guarantee the backward
compatibility of on-disk layout. These fields were never used before. Also,=
 we
don't need to expend the inode size, currently, because such expansion could
break the backward compatibility of the on-disk layout.

>=20
> In any case, the above fields cannot be consumed unless the
> implementation policy for xattrs is decided.
>=20

If we are considering the inline xattrs, then inode should be extended. But=
 it
could not provide the enough space if xattr is big or we need to have multi=
ple
xattrs. Potentially, extents tree can contains different types of extents (=
user
data, xattr). And logical block is allocated for xattr should contain header
with metadata explaining the all xattr details. Does it make sense?

Thanks,
Slava.


> >=20
> > [1]
> > https://elixir.bootlin.com/linux/v6.19-rc4/source/include/uapi/linux/ni=
lfs2_ondisk.h#L37 =20
> > [2] https://elixir.bootlin.com/linux/v6.19-rc4/source/fs/nilfs2/inode.c=
#L413 =20
> >=20
