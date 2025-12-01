Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0CDF72
	for <linux-nilfs@vger.kernel.org>; Mon,  1 Dec 2025 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764614528; cv=fail; b=nEuVWsMUilo7w0SVSUOe4RkX5ayRlu3SzaF0J9brAFV1tFHQPMLpygKG4SqrHRtUowEpV5klGv+Xm+q+8yyL+Jzt1v0cT2nhQ2EqQ26PvKtxLqpiNVm59W5UqcwLW2Op7WC9S3DpyiAbOLdymmM84j3P3ZGGgNyN2XPcZrJHH8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764614528; c=relaxed/simple;
	bh=QT7zVE3seFm1Zk1pCI5Ok6qQ4TOaTL0FvdrWZZ90Hl4=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=fhBbBWcEGMwdf3Y3A+J694z0fDKodnil216lh8XwSF7ZwdhotbwThvtFuK1S3dZiOCtIbD7GVudqM02DfT/b6zGPrS4J0yDXxsDc8AwOJjR9wtOq4Jg/c5ECvttP9S9dhHRN9nt1AyMeNV8foaWGoO0hNx0IHjRSYf5BGJUrv7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IEcsHO2C; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IEcsHO2C"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1BfGeR027754
	for <linux-nilfs@vger.kernel.org>; Mon, 1 Dec 2025 18:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=gp/lrbyAgqQ8hgi+tnr9M8qRKKQmmW806Z+MrKY070E=; b=IEcsHO2C
	bh0lrMWNgcLGbx827KNcX9vE0W1NJX5FTW0meuUQwB4OE+DAhvVpI+Ea9OrS765V
	h+02iAV3796D1IGQalceSARQGCyKa01Tn9EPbWL+jPyxpCnO9WzfMO6K70tXjppm
	GEeHcKSzwTjXS5MWII/qROkmOR58ZeNP/MLaUoV5b8sxmjQG4xpxCOViiR182bxf
	8z6mjE8R8n1HpHDT0BEqhtaLv2KSU4OZC8Sc+oPbQeKiuOPpAqU+n/KgwlRhpnaI
	t8jGET+r/B0XaydYnzJ3BCSBkQu8GquYfz1jHpbwdhR9M+/fEqrkmCWjNoWlKSdB
	Cyq4/AiPnEK6+g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqp8prx8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 18:42:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B1IVuJF007614;
	Mon, 1 Dec 2025 18:42:04 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqp8prx8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 18:42:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u/ZOU+j0LURnGJlNTZbps01OzZSBKcKlE9bEEAv0yqupKl1DvociNnIp83scNXqjvHOStBYt3mMZ8Mwg74rn+Pck+bjaOIUZskHdwY2S4i0XpOd+P5eL3MsGNcAB9nqNYaGBUkwr7o81+53gGgZHacMgz6TGxYi2fqb6YY3cG5zmaHVywKpFLwkNl6kcb47fEGO5wc/GnV7j2fh/7LqvLHKPslyoP8fVpilQzFjQUwfM05vWGG1t3R0hVRTJwKPQ2Fdh88LZIQxjM1rFUt4G6JhJEPL/ChVO7kZAVCV2GhGji7gIuoJYXQPqxssNAQ2w0b8onhXBMs41aIkkL8IOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFHlzRLk9n+8pOHVJVFFtXNo8NV0Ee8NOrLPkk+JCRs=;
 b=uGRbmhh4IVICLhidJ6rhQwuAzNvADjkWBV2RzrhWOVLRPSQZh2yM0OyonmZSB9BT/LDRTGGAkZWz0LSrpi5wNmRUrgn4QKwHuQ2peNZziOXfuOkc2W5Ih9idsRL6sRGfqvYZBolVc8rjrC9AC32LSnr9EQVqpwCtDZskLUxgD8nIgclWsZ5JK3IgJscnrRwquewDD7l/UY+3w1P0EesTkq7oOzAcp9b+n38Cc0p8AqU8GprrtSty0u4mNSllq6F9N8FfhFkJ0NHwESdHVoXN2+QbM1N0W1AZa45P12xc6sbinAqeGnLxKiar+KMk4lbDRsWc1lMJUwJihdqy5antrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SA1PR15MB5139.namprd15.prod.outlook.com (2603:10b6:806:233::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Mon, 1 Dec
 2025 18:42:01 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 18:42:00 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>
CC: "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
Thread-Topic: [EXTERNAL] Re: Status of running xfstests for NILFS2
Thread-Index:
 AQHcVPxMvOR0TznASUaKKmt1+Qe6frTz45oAgAU3GQCABB6UgIAFFJ6AgAKxfgCAAKKygIACNkaAgAViBoA=
Date: Mon, 1 Dec 2025 18:42:00 +0000
Message-ID: <4631272e19f77b681e71ad649a23705c63cf34fd.camel@ibm.com>
References: <ad4826a48dba37fee0fa9949bfdeef8747ab8e93.camel@ibm.com>
	 <CAKFNMok6sj9EPgCBSn=3Uc1ze51jbPH69xEXQtFTej3B1JcTLQ@mail.gmail.com>
	 <66926bf9a9cb9488dd5f8fe9493d366fb3fd7e66.camel@ibm.com>
	 <CAKFNMokvQpOS6KcyxKjHs9bQ7a6Oi37EaaMD+0Vp3xE6HuYOkA@mail.gmail.com>
	 <c2b125c3f1a2b792241800c3fa7b6d6b56450add.camel@ibm.com>
	 <CAKFNMomX4eBT2xFyK3XpK86ghEyB=ZGsLZr7H2C_xqm7Ysusyw@mail.gmail.com>
	 <6b77c17169a39f75f4731073b3315df25f706e82.camel@ibm.com>
	 <CAKFNMokERKfS2GyYhs5DJ4Yb=5Gw=-cD_GOaksvmPkoSj3G9pg@mail.gmail.com>
In-Reply-To:
 <CAKFNMokERKfS2GyYhs5DJ4Yb=5Gw=-cD_GOaksvmPkoSj3G9pg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SA1PR15MB5139:EE_
x-ms-office365-filtering-correlation-id: 1be405f2-e2a5-4657-2222-08de31095088
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WHh1WDdza3ZPWVF5cWZPTWppQ0NmbkwySVF0ekw4dmdvR0dlWlVLUHhmNCtZ?=
 =?utf-8?B?UTA1Q1JlR09aTVgxOWIwTkFPVnBqNGpxRTBsdG56Tk9rOGFZeTU4MG4yUmdw?=
 =?utf-8?B?KzBLTkwwVUNkYmpScjZaaG1RVW9Nc1ZycGZpQmFHL3NmQ0FMd0tmVjhkMmE0?=
 =?utf-8?B?UGtucWVlTmU3OGtucGJkTnk5NjIzaXBvK0VvN0ZzY2gzWk95OHJpYVBaNXBh?=
 =?utf-8?B?SXg4bHdIckxNZWJIZWU3dkc4TzJzeGgxbG43SWh4Tk5jRVNMbFRDRGZ2RXdr?=
 =?utf-8?B?ODgyNURjQlhSY2tPaHdhMEpySVYwems4aGMzRjRpNC9PNisvOUlESGY0RnNK?=
 =?utf-8?B?bTJPQzRDU1FqdVBUSExLNGd3ZTdKaXZ3TFRFU3poMjQrNkFHc05MekRHdzI4?=
 =?utf-8?B?b0NvVTVPVjI3emxKT2VNbmRYak00REpvbnJmMkMvNmVEaldVUnhCd2NqZnpD?=
 =?utf-8?B?ZHZRNk9JanRJY2FxWTNzc1Rmdnh4Y29GZklRUG83Y0RCVjhmTFNvNm9oMURR?=
 =?utf-8?B?cEszWGxJUHI4NFpkNUJOek45QSs3eUVyWkYxWFNvR05ZOVpzMHJIRkZ4ZWZ6?=
 =?utf-8?B?R1BXckVMSkJMQ2YrQ0U0enNqZWhIRktJUzRJZU5HZTRua1NDTmM0b2FzTEw4?=
 =?utf-8?B?SVRTZUNlbHFOR3czQlhKTTBzOUFyQURiNThRcjhqM3F6N3dxbFZlNkh3NFhW?=
 =?utf-8?B?WktyZTl3SWNOZnRIL3FyWkhkKzZ5OW9HYUdQOFBXRUNQK1NSRUltM0ovTnI0?=
 =?utf-8?B?eEZlOGNpRDdNYnpLZXp4b2lvUVlPNEdneTNsT0Nxc1lkTkZ4UVRFd2xuSWhX?=
 =?utf-8?B?aWV6NUUxQ1hoQ04vK1loTHF2WW1nVGJBWFFzREM2SkxMU29iazlMOGlEWWhB?=
 =?utf-8?B?cldJSHJLWVlVOEkwamtreE4wUFQyWi8zMmlrTnlMWW8xdWpOZFAwdkQxZ1Rn?=
 =?utf-8?B?dXluamdmekRwWjNCNEIzVDlzR2t6U01VQUNCSHNBUFlEV081MExuNWJtNEpD?=
 =?utf-8?B?VUpTRk1hditnb0tnY3V5K1NxMFIrOVVmOVVrdUdJd255eFBHSE5FT0QxZG5n?=
 =?utf-8?B?TWR1eVAwYnRQUkVTb05nNGNxODVKaXN4UkxZbEJ2bDV5L2l1ZzdoOHkxVEFp?=
 =?utf-8?B?MkIzK2xrRlp6NnQ4anFMQmZCMzlnWW81WEZKV3N6bW9JaDB2d2xKTjlZVWxs?=
 =?utf-8?B?dWJkZE9pSFlVWTdGZ0t4MWJPWnN2YU5wYUhyMEw3UkRkVWt6NDh1L3VDZHEx?=
 =?utf-8?B?MG1kMTRaaVJuZkV6b0lGRkFER3VMczdPS0JIT1dDY1BuekFvVVVaYkZIRXVy?=
 =?utf-8?B?OVloZG1oQkJ2YkdBUGdnM1NKTGQzd3Rvb1FPT0t3MkZBd254S2NUajl4TUps?=
 =?utf-8?B?cDhaMFdxRVhxWTYwNVpveVNPT2hjdm5oS0hBaWN2RXRqZ01FWWNzbTZQc29H?=
 =?utf-8?B?RExYK0YzNzY1UjRVVUpIL0ZMSno2NXhQS2tSbHNpSkROc0MyTlhtb0tNc3NS?=
 =?utf-8?B?NkZCMHpqVUVCZ1NWZitwelFrUkxzMDJSTlJhYjlQbDA5U2UyOXFvR1IrNHZ4?=
 =?utf-8?B?ZDFMTXBDMDFNbjlpRFpOYkRYZHNXMTZuV3lOUEZWbmJlam9mR1B1SndKaDEz?=
 =?utf-8?B?Z1lQTHdvdDJ6VlBPM0FxZG9IZW4ySlZ4NkEyVVExU1ZwOTVqV29hbHhJOWFH?=
 =?utf-8?B?ZVdFY0k3QnkvZy9WUWxCY2dyR0RkaWZZRzdxdkZoUTlvS3F0UklKY3lLRmJ4?=
 =?utf-8?B?RXBJekdWWXQvQVU1ZlJoSzVPQ1o0b1M1UXBIcEpDVlZadlZHSlUySTY3bzEv?=
 =?utf-8?B?Y05YYUZrRUs5TkZFY0Q0ZlJkODBhc3VibFhtK1I2ZndSN3JIQmNMS1l2QXVv?=
 =?utf-8?B?S1k4N0dDRXF2TmYyNE5iRW5JYlhkK01LaFIrbzRVRVhCbmxKUkJaQmVDcnd4?=
 =?utf-8?B?cmNncnIzSkZ2NkxkSkVlK3BXU2dSMk5ienZDdWFnbHFTWnZxeG0xWjdqNHhS?=
 =?utf-8?B?MXVYUmU3S0hRdGRJT01hTjFkMUorczVvY1NOR3JSeEhtSjlHaTZpcEJkY0dV?=
 =?utf-8?B?YzN1dklFVXBmTXhTcXdtVlBmcXllUkRXdk1Jdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTRyMmwrNjlnK1NYV0xoQXF4R3U4cEc4WGFNaHlHenZyYUNHZ09PVWg0UHVM?=
 =?utf-8?B?RkxkQldBQzF2VEFseVRQa3FzNjJPdTFpY1I2WEhzNVVDK2NXOElIVUlmSHhr?=
 =?utf-8?B?b2dVYUl0OHd6eXdacXY1UFlaZjRGWkRRNWNYNjFsRjk2ckc3TkdjdmRDaFAr?=
 =?utf-8?B?L1ppTjRJTDNVWkZQUjdZZDJ5Y3UyQ2RmMTdRTTJhUVFWMFhvK3VUeWM4R0xV?=
 =?utf-8?B?T0lRa1dYcExpeGg5eVRzdEViUHN0MVVCM1pVLzZDUzF2R29CNzV3ZkFjK0Y3?=
 =?utf-8?B?UjdhWjY5SnlOVjZ3UjFzcGxxU1NtTkl0QXRoZDFuRzIrSm95RWNCU056OStE?=
 =?utf-8?B?VzBmcmpqNDhrTDZFeG5uL2xRYmZPTWhjZXhTSTlVQWhIQ0RDdlFreXJhNUFU?=
 =?utf-8?B?YWVLcTY3TjRBR0NxcGY4VXFWUXRuOE9UQ2R0RVNYYkRCTjBnMThpbm91b3o4?=
 =?utf-8?B?S2JScmFsbmtyenVpRDBnOExpV3lnbkhmOXdnMmFVTG02OHF1VHRYUkpNQWRh?=
 =?utf-8?B?UW9VOFVuSFpRWXk3ejJWMDFxYXpkUUoxZGp2L3BLdEhaMGZDSDZ6SVBhTWdE?=
 =?utf-8?B?TmVzY0hZd3JuRnovYS9kZklFbWJSRWRpRlpvVlZ1TDJqOU92VDFSSTk2TUFU?=
 =?utf-8?B?TGYveW9qKzllSE4wdUh2VkgwaGJ1Z004OEJXVk8xNmltb1BTN3lTN1BrM2pu?=
 =?utf-8?B?SURaUnZNaGs2b1VVU0hDamxFWjZ3RTc3L1FWelhiWnI3aWlGSHFxb1N0c01j?=
 =?utf-8?B?VUE0aVpZck5xYmlRRWtyVWpBQVY5M2J0WTBlQ0paYW5UNU1xcDU0UHYrSUY1?=
 =?utf-8?B?RWp5MHJQcFpqTTEzalhzNEpPSCtrbEVWT3lQUS9LSnJSb3FZUVZxNTU0NFNl?=
 =?utf-8?B?UW4yOURDQ0twQ1FuSExmdHNvWHZOUzc4M05mSTY5bzRveHVyWitlY0NqK1dk?=
 =?utf-8?B?SE9MK3VPb25KNWxQeGJHaFQreFNVVVduRFpaYzVySnJnaGpHblN5VGRNeVJz?=
 =?utf-8?B?Rlc1NjJQWXFidkJWbjdIVC9wVGI1eTA4RDl5UDBtZm85bjB6ZTl4R0dGczVl?=
 =?utf-8?B?eTJoM0RDK2xJV1U5TFZ6OUdmQ1RHVnRieE9PL3YyZGRQaVlpUGN6Q09oamsv?=
 =?utf-8?B?a3RubDl5Y0JGYXFJakI4bEo5NVg1VWdWVms1MzNVTGNrYzlqM01sK3dxeUtS?=
 =?utf-8?B?a0tUZXFJemlkcDJFT2xNMjkwcWdham1oemxvaVQ4VkpteTZkNlM5bHBBMjl6?=
 =?utf-8?B?YTNseHpWZDRvNUIzcjR3MElIN3NhS0R3Z3RTLzRSRko4dU1pWmVUOGE2WEJE?=
 =?utf-8?B?OU13Qyt1SlNrdW03M0xVZ1FvY1Z4T1d0TlVBaU9GQVBFeXdLalFDemJpVndj?=
 =?utf-8?B?V0JuMmZmN21TNnA4NSt0WnlHOG05cThTOThLN1BQaVQ3MjY1RUg0K2oxNGgz?=
 =?utf-8?B?UjNVWnZveG5FYTkycUVoUEZReW9ZQUdKUit1T2p3Y1BXdkVaZTF3LzNSTllT?=
 =?utf-8?B?ZVdVOVVBVUxsR1F3aU5rMmo1U1R3cnFnbE13UUF5NnB0dXp4YVY2NVlQQUJr?=
 =?utf-8?B?bmhvaEpVbmJ5aTlobXphUGI5Y3Zia09lU0Z6WW9ucVZVam52bDhUdzVTQjlx?=
 =?utf-8?B?TEowQVNveTNPbVUzMm80QkR4OEM5RGdMTjlFdU1kWU5SZERtdVIzcTZsR3Jm?=
 =?utf-8?B?eUVQT2NDNGV2bE03NUNUb20zY1lneEtnUHM2S0RCQWh3ZkdpNytOY29NN0VK?=
 =?utf-8?B?MXBoQzhYWDJKeEthUHE4blBsNEdUd2pXajBtNjNKTzI1L2NFMEd4WUN0SHZl?=
 =?utf-8?B?TzhCY0xjdkwvS0N5U2N4bURzdGdWNTFtTGNDbzRwUmdMbnNhNUxtVllMMk0w?=
 =?utf-8?B?MnNrS0l0ZTY2V05yejc3ckNsa1BDVDlUYWdCSHZWdVpVR1BXanMxYXc1Z3Vh?=
 =?utf-8?B?VnFCS2Q2SkQ4RDlLVnMwTDA0VWNxV2Y3SlA0UjYrY3JCckVZdDU3WWlVcVZi?=
 =?utf-8?B?ejVJUHpFei9PdGVRVTJscE14VHBWY0NOOE82RGxHSGx3eUIwMVF3S0pkeHc2?=
 =?utf-8?B?UWJxN3JDdzZXa2kzRlNQMGoxemF1amJFMU44QkQ2Nk1pOVEwSU1hVkptNC9Z?=
 =?utf-8?B?bjZwVzlwWEZmUWorVFBWWE9sWmk5cm1VQk0rdHBqTFVreUt3ajVBd25vOVBK?=
 =?utf-8?Q?pP0yqMFLWRtsn4/fEN89BV8=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be405f2-e2a5-4657-2222-08de31095088
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 18:42:00.8252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s+CINZxx2+oHZPynuH0396Ppp+tdtesgYb1gsgSubOploastcUhN91nhpoADR8TtdHvfL0K17VR1QO+qrJ9uLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwMCBTYWx0ZWRfXxiuLk0XzO34w
 nI0/qceeroXj7j1ReXbLxpUcLoyz0sMXsZgL8knEBKPUoSkE7dt9+qKqJp0G1TLN+4bdt0xcPNz
 T3l+AQBoS4WFUpORpttvUedpw2TdS9bmMP30wU3HwzwLSuZTtuNw6QZtAW8xRSjPYu703ZjkEKc
 k0UITV0aGCtJBLhQbAxk+eEtnOFDyG9TZUP6I2mKk9/oPZjg5Aifw7Sbs2y1UAVujxWTVSqKf7U
 1BJ68Hfmbwpn4lRnBSlFF6q43IDoYwTTUc69FQgfLTqN0w8zgnt9rW5oRPp8WCHg3dbKJnFWygD
 +J1KWYFZLTu1W5xHL2aTeoSpNLMv5L0q+QXaHY75YH1OI49moAMWtQ75icqB4fGkI6nALRfE2qO
 ttwDkC1YAqMQbCWJg3QqJ+Q1Ax1F1w==
X-Authority-Analysis: v=2.4 cv=dIerWeZb c=1 sm=1 tr=0 ts=692de17d cx=c_pps
 a=VtjYC05bhoYYzE9JtrBllg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8
 a=yPQ6tL9foMlMTKLYDqkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: a_sxTaaX9-dvNOaxIei_V4nvLG768nWX
X-Proofpoint-GUID: 7daRxhYWynX8RemA3UDukb7OWHnMyAc2
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DDA42E5C2F09946A612251D845DFCF2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: RE: Status of running xfstests for NILFS2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290000

On Fri, 2025-11-28 at 17:29 +0900, Ryusuke Konishi wrote:
> On Thu, Nov 27, 2025 at 7:43=E2=80=AFAM Viacheslav Dubeyko wrote:
> >=20
> > On Wed, 2025-11-26 at 22:00 +0900, Ryusuke Konishi wrote:
> > > On Tue, Nov 25, 2025 at 4:53=E2=80=AFAM Viacheslav Dubeyko  wrote:
> > > >=20
> > > > On Fri, 2025-11-21 at 23:17 +0900, Ryusuke Konishi wrote:
> > > > > I'm still looking for good BTS, but it might be quicker to start
> > > > > making them on github now.
> > > > >=20
> > > > >=20
> > > >=20
> > > > This was my point. :)
> > > >=20
> > > > Probably, you need to enable the issue system for NILFS2 on github =
somehow.
> > > > Because, currently, I don't see anything available. And I don't rem=
ember already
> > > > how I did it.
> > >=20
> > > Okay.
> > > I'm thinking of creating a nilfs2 (linux) clone repository at
> > > https://github.com/nilfs-dev/     so that we can file issues there.
> > > Is that okay?
> > >=20
> > >=20
> >=20
> > Yes, makes sense. Looks like a good place for collaboration.
> >=20
> > Thanks,
> > Slava.
>=20
> I've set up an issue tracker on GitHub. It's at the following address:
>=20
> https://github.com/nilfs-dev/nilfs2/issues =20
>=20
> For now, I have registered the syzbot issue and an issue that has been
> reported recently on the ML.
> At the top of each issue, I've included a Link: URL with a reference
> to the related syzbot dashboard or email post.
>=20
> What about the xfstests issues ?
> Shall I add all 156 reported failures? (In that case, I'll just create
> separate issues and include a link to your original report for each.)
>=20

Great! Let me check that I can access it.

I believe that it makes sense to create a dedicated ticket with enough deta=
ils
for every failed test. I am ready to create these tickets but it is not qui=
ck
process. So, we can do it in parallel. I could be not very productive during
these and the next week because I am going to spend time for preparation and
attending LPC 2025.

Thanks,
Slava.
