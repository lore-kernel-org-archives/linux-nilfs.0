From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v3 1/2] nilfs2: remove double bio_put() in
 nilfs_end_bio_write() for BIO_EOPNOTSUPP error
Date: Thu, 15 Aug 2013 08:41:12 +0900 (JST)
Message-ID: <20130815.084112.220043622.konishi.ryusuke@lab.ntt.co.jp>
References: <1376401833.2274.9.camel@slavad-ubuntu>
	<20130814.015148.316894835.konishi.ryusuke@lab.ntt.co.jp>
	<20130814160001.3fa9e4dabb7dca81dab31e87@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20130814160001.3fa9e4dabb7dca81dab31e87@linux-foundation.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, DanCarpenter <dan.carpenter@oracle.com>, linux-nilfs@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Wed, 14 Aug 2013 16:00:01 -0700, Andrew Morton wrote:
> On Wed, 14 Aug 2013 01:51:48 +0900 (JST) Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> On Tue, 13 Aug 2013 17:50:33 +0400, Vyacheslav Dubeyko wrote:
>> > From: Vyacheslav Dubeyko <slava@dubeyko.com>
>> > Subject: [PATCH v3 1/2] nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
>> > 
>> > This patch removes double call of bio_put() in nilfs_end_bio_write()
>> > for the case of BIO_EOPNOTSUPP error detection. The issue was found
>> > by Dan Carpenter and he suggests first version of the fix too.
>> > 
>> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
>> > CC: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>> 
>> Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>> Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>> 
>> I tested this patch by inserting a pseudo EOPNOTSUPP error, and this
>> actually fixed a crach "kernel BUG at fs/bio.c:498!" due to reference
>> count underflow of bio_put() that nilfs_end_bio_write() induced.
>> 
>> 
>> Andrew, please pick up this bug-fix preferably for this cycle.
> 
> Should we apply the fix to earlier kernel versions and if so, how
> far back in time does it go?

Yes, I think it should also be applied to earlier versions.

I looked back ealiear versions.

This bug, unfortunately, comes from the original version (2.6.30), and
the patch could be applied to all versions.


Regards,
Ryusuke Konishi
