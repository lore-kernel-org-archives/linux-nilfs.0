From: csmith-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org
Subject: Re: free space not reclaimed
Date: Thu, 23 Aug 2012 01:14:21 +0100
Message-ID: <20120823001421.GI16953@csmith-bm.vm.bytemark.co.uk>
References: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039@netams.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0D65752F-DE69-4A4D-98B3-6C1FF5FE4039-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yury Shkandybin <jura-N6MIjFY6MsTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 21, 2012 at 03:57:17PM +0400, Yury Shkandybin wrote:
> Hello.
> 
> Recently i overloaded my nilfs2 partition with data.
> /dev/sda2        30T   29T  122G 100% /archive
> I've removed 4T and issued:
> rmcp -f 1.. 
> nilfs-clean -p 0
> , but used space left the same.
> Actually it keeps increasing.


If you're using the FS as an archive, then you're likely not
overwriting or deleting data, so the cleaner will simply be shuffling
live data about and not actually freeing any space. The 4TB you
removed may well a long way from where the cleaner is currently
cleaning.

If you're archiving data, then I'd suggest NIFLS is not in fact the 
best option to use.

Given the size of your archive, are you using this in production? Or
just testing?

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
