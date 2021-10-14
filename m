From: Anton Altaparmakov <anton@tuxera.com>
Subject: Re: don't use ->bd_inode to access the block
 device size
Date: Thu, 14 Oct 2021 09:32:58 +0000
Message-ID: <3AB8052D-DD45-478B-85F2-BFBEC1C7E9DF@tuxera.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211014062844.GA25448@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ntfs-dev-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=MIME-Version:Content-Transfer-Encoding:Content-ID:
 Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From:Sender
 :Reply-To:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To
 :Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=zbz1+3E8f26AvINF6ASLwbcONz2i1Mlf0y4UWRBsk48=; b=KtKsW++wdoC6+nK41p3S+k8ioX
 lIiEPwKXSXEJILOfeGj5uLj0OGQtiQVq2x7oRpM8OYJ91/LKk1CxDqnvPDUm7Q4Hpb8hb23AOptsT
 /w4MSeo8/QThHmM92eLlcjGHgk8hlw3fEHJ14JUvMJEV86YNlcc5o8YdUH3xzkMejqIg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:
 In-Reply-To:References:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=zbz1+3E8f26AvINF6ASLwbcONz2i1Mlf0y4UWRBsk48=; b=kmlIlPkY39OFE+8y+2cBBscrEH
 hiTjsAvGITRd9avlcK3pUif8+U+jTf6OmMVABcalX2QeOlbI01LY+HgG+pXZBvrDpTEUbcNuAm3bH
 K3EHHWRbbbuhgKML8B3+ADyFwjkFrrkRhn7gpKLMYgADW11JtY//+nUOOtGJmAuNwCo8=;
In-Reply-To: <20211014062844.GA25448@lst.de>
Content-Language: en-US
Content-ID: <F1129580E148624C920474BEC9F515C5@ex13.tuxera.com>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-ntfs-dev>, 
 <mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-ntfs-dev>
List-Post: <mailto:linux-ntfs-dev@lists.sourceforge.net>
List-Help: <mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-ntfs-dev>, 
 <mailto:linux-ntfs-dev-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-ntfs-dev-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@kernel.org>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, Mike Snitzer <snitzer@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>, l

Hi Christoph,

> On 14 Oct 2021, at 07:28, Christoph Hellwig <hch@lst.de> wrote:
> 
> On Wed, Oct 13, 2021 at 07:10:13AM +0200, Christoph Hellwig wrote:
>> I wondered about adding a helper for looking at the size in byte units
>> to avoid the SECTOR_SHIFT shifts in various places.  But given that
>> I could not come up with a good name and block devices fundamentally
>> work in sector size granularity I decided against that.
> 
> So it seems like the biggest review feedback is that we should have
> such a helper.  I think the bdev_size name is the worst as size does
> not imply a particular unit.  bdev_nr_bytes is a little better but I'm
> not too happy.  Any other suggestions or strong opinions?

bdev_byte_size() would seem to address your concerns?

bdev_nr_bytes() would work though - it is analogous to bdev_nr_sectors() after all.

No strong opinion here but I do agree with you that bdev_size() is a bad choice for sure.  It is bound to cause bugs down the line when people forget what unit it is in.

Best regards,

	Anton
-- 
Anton Altaparmakov <anton at tuxera.com> (replace at with @)
Lead in File System Development, Tuxera Inc., http://www.tuxera.com/
Linux NTFS maintainer
