From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [RFC PATCH 29/34] power/swap: use bio_new in hib_submit_io
Date: Thu, 18 Feb 2021 01:28:03 +0000
Message-ID: <BYAPR04MB49652FAADFDCAA3DF72DDEE186859@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-30-chaitanya.kulkarni@wdc.com>
 <20210217220257.GA10791@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613611694; x=1645147694;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9qH2YcBXObP3U7J9syAbJhGF6oEFdit3Uuies5zV6L0=;
  b=jRIiLwxGwDDlwFBZ9wzV8ieaActAaGzXZKfiau8M0idAh9GC1/b8ynU+
   5lbHQFcmSQVNAwjcH5gAY5Z3Ew2NpvzWTNHkQD51hY11blAMl0Y8GUg7a
   xIbG8UJ7dFoZeX+DizISrJ+P8pZotxnoMO58lrwTEGWscLT+2NXv8obdO
   SKI3qVG5Mn3rJJ3u+bq7hjOlm1TrojqAIksOGVa1Cwlo3KAiE3i2TsN6b
   sP4Kcklv/51crOBaV4k+bIHK+ZkFescFlnRawdiOfqavlbFn2I8QTp2AZ
   vhpMB/WSVZV4QxMnfR01Cen4BSBSq89hPJXZzUfiUq/wiBS2QEs3EnDnR
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVXbQhzjMljenFFGdNZDlx1QlYnqBP6C3iQWXjZAeDQ=;
 b=iMEzjUgowwL4XBlFMbTYGFc9RSs3LvDC4WW6RrbatNzS7M+z+PyPrjOSGE6fAOGm592UnzFD8A7h93qDIuXnq9uKDUbExBwysGUd8rs6aYwe7pKW6YjBYZL8YQshg3SnC3pqPIF1BU1dXdY1nP0og2xoM8Xmxfh5ANKbKh/4HrE=
Content-Language: en-US
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-pm@vger.

On 2/17/21 14:03, Pavel Machek wrote:=0A=
> Hi!=0A=
>> diff --git a/kernel/power/swap.c b/kernel/power/swap.c=0A=
>> index c73f2e295167..e92e36c053a6 100644=0A=
>> --- a/kernel/power/swap.c=0A=
>> +++ b/kernel/power/swap.c=0A=
>> @@ -271,13 +271,12 @@ static int hib_submit_io(int op, int op_flags, pgo=
ff_t page_off, void *addr,=0A=
>>  		struct hib_bio_batch *hb)=0A=
>>  {=0A=
>>  	struct page *page =3D virt_to_page(addr);=0A=
>> +	sector_t sect =3D page_off * (PAGE_SIZE >> 9);=0A=
>>  	struct bio *bio;=0A=
>>  	int error =3D 0;=0A=
>>  =0A=
>> -	bio =3D bio_alloc(GFP_NOIO | __GFP_HIGH, 1);=0A=
>> -	bio->bi_iter.bi_sector =3D page_off * (PAGE_SIZE >> 9);=0A=
>> -	bio_set_dev(bio, hib_resume_bdev);=0A=
>> -	bio_set_op_attrs(bio, op, op_flags);=0A=
>> +	bio =3D bio_new(hib_resume_bdev, sect, op, op_flags, 1,=0A=
>> +		      GFP_NOIO | __GFP_HIGH);=0A=
>>  =0A=
> C function with 6 arguments... dunno. Old version looks comparable or=0A=
> even more readable...=0A=
>=0A=
> Best regards,=0A=
> 							Pavel=0A=
The library functions that are in the kernel tree which are used=0A=
in different file-systems and fabrics drivers do take 6 arguments.=0A=
=0A=
Plus what is the point of duplicating code for mandatory=0A=
parameters all over the kernel ?=0A=
=0A=

