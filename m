From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFD] disk format fixing
Date: Tue, 4 May 2010 14:02:22 +0200
Message-ID: <20100504120222.GA1132@heethoofdje.13thmonkey.org>
References: <87aash3rrm.wl%jir@sekiba.com> <7E6B7E93-FCB4-4E4C-AF4F-BEA8D8FE1F20@nop.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7E6B7E93-FCB4-4E4C-AF4F-BEA8D8FE1F20-Nqdcz63CPQY@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jay Carlson <nop-Nqdcz63CPQY@public.gmane.org>
Cc: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 03, 2010 at 03:35:03PM -0400, Jay Carlson wrote:
> On May 3, 2010, at 11:54 AM, Jiro SEKIBA wrote:
> Low-end consumer flash (like USB thumb drives or MMC) often uses a simple
> zone-based FTL with bad block replacement.  I am told really cheap ones
> allocate zones with 1000 flash blocks with 24 held as replacements for
> failing blocks and wear leveling.
> 
> If I understand nilfs, its superblock is both fixed location and "hot": it
> is written fairly frequently (on every fsync?)  On cheap flash, it will wear
> out the flash block it lives on in 25 write lifetimes or less.  

I'd opt for NOT writing out the super block but on unmount or when the
roll-forward chain is disturbed by the garbage collector.i

Another option is to never update it; it should at most take a few secs to
locate the latest segsum by just scanning trough the segement summaries;
especially now the segment summaries have the checkpoint number incorporated.
If on mount all first segment summaries are read (say 4000 to 8000 sectors)
its clear wich is the newest and then follow that chain until you reach the
end... and you can mount. I agree its not optimal but i dont see a reason as
to why it shouldn't work :) It is also backwards compatible since older
implementations can will search for the last super root; they only will need
to read more.

With regards,
Reinoud

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
