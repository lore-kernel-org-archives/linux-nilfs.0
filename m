From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v10 00/62] Convert page cache to XArray
Date: Sat, 14 Apr 2018 12:58:59 -0700
Message-ID: <20180414195859.GC31523@bombadil.infradead.org>
References: <20180330034245.10462-1-willy@infradead.org>
 <a27d5689-49d9-2802-3819-afd0f1f98483@suse.com>
 <20180414195030.GB31523@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ATgzrYnfLzeXsydg+R9qrgcpOo0DmmtIWygsjBX8iso=; b=bjND4j670rgIjuC8SNafAos/q9
 /CuwzNmsojUqtg60Mug2gK8Jem3FDSdBbcubU1kC9ORe4Upk3b8INjzV//7jFNffV2qn4YSh0HH2z
 9JVeoeaPeWN/LMuOz1VZGOGs8b63rZAaYNh6sWYSCEjwTzdY9k1OykTo/VEBGySx4pG0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To
 :From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ATgzrYnfLzeXsydg+R9qrgcpOo0DmmtIWygsjBX8iso=; b=bzvwNDxeeWw9x5r4re6ChalN/Y
 jO1+ebs0IyT+EPzecKsx9R+7gjyFgBPYqBgPKlH8x3x7kzqkUZqh5pNBpxip8W5HnUpdhIXE8lKdF
 lSr7GR/3nrIi3R1Z7s2fakU+t04gAIU33UkdBKzlY1X8ojjwGPuwje8InDEn62Wnr/QM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ATgzrYnfLzeXsydg+R9qrgcpOo0DmmtIWygsjBX8iso=; b=e4oMpwHuusDF7hs9xcgjauDhQ
 SkS3pHIoYw4yDGwKXy5jXcHK4i4N+bhZNe8wEZD1X5WHgNTBpuy7+8QpekNUlHgRPZRaix26L7sjP
 sQj6w01OARQi85y+2ZmqkbbwVOHcbybq0AUX5DekPcQb3VYgWMyVo8jTcv8yVA17KL8QzBmixkTT8
 +TtJOk8JZZyAq0K89e1rIkmBZA+HxJ3K5l/52to/yQl7cpy2lDc1NMizv/EHjVaCo/+IUTTjnxGSZ
 n1Nl2wjugwbSNdF1Bj7K6xe1IZaKtZhEoNf0CkS3AG2u8umpMwEaGAqwhcKGX/HwdHaFt2hmbjZHe
 ZldVTakRw==;
Content-Disposition: inline
In-Reply-To: <20180414195030.GB31523@bombadil.infradead.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, James Simmons <jsimmons@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Andreas Dilger <andreas.dilger@intel.com>, Nicholas Piggin <npiggin@gmail.com>, linux-f2fs-devel@lists.sourceforge.net, Oleg Drokin <oleg.drokin@intel.com>, linux-mm@kvack.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Mike Kravetz <mike.kravetz@oracle.com>

On Sat, Apr 14, 2018 at 12:50:30PM -0700, Matthew Wilcox wrote:
> On Mon, Apr 09, 2018 at 04:18:07PM -0500, Goldwyn Rodrigues wrote:
> 
> I'm sorry I missed this email.  My inbox is a disaster :(
> 
> > I tried these patches against next-20180329 and added the patch for the
> > bug reported by Mike Kravetz. I am getting the following BUG on ext4 and
> > xfs, running generic/048 tests of fstests. Each trace is from a
> > different instance/run.
> 
> Yikes.  I haven't been able to reproduce this.  Maybe it's a matter of
> filesystem or some other quirk.
> 
> It seems easy for you to reproduce it, so would you mind bisecting it?
> Should be fairly straightforward; I'd start at commit "xarray: Add
> MAINTAINERS entry", since the page cache shouldn't be affected by anything
> up to that point, then bisect forwards from there.
> 
> > BTW, for my convenience, do you have these patches in a public git tree?
> 
> I didn't publish it; it's hard to push out a tree based on linux-next.
> I'll try to make that happen.

Figured it out:

http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-20180413

aka
 	git://git.infradead.org/users/willy/linux-dax.git xarray-20180413


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
