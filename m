From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Re: null pointer dereferenced with Ubuntu kernel 4.15
Date: Mon, 9 Mar 2020 19:42:40 +0100
Message-ID: <20200309184240.GA14772@dropje.13thmonkey.org>
References: <24166.20345.583274.370928@base.ty.sabi.co.uk>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <24166.20345.583274.370928-jdnFGoDsuNlYO2OccljXW7VCufUGDwFn@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Ik8g8846gVy9@public.gmane.org>
Cc: Linux fs NILFS <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I have these too, it looks like something in the linux kernel must hsve
changed and tgey didn't test or looked for issues in the nilfs code. It only
starts here with writing on a previously written volume. A new volume works
fine.


On Mon, Mar 09, 2020 at 02:15:21PM +0000, Peter Grandi wrote:
> Dear NILFSers I am perplexed because on upgrading my standard
> Ubuntu LTS kernel "4.15.0-88-generic" I keep getting null
> pointer dereferences as per attached kernel messages, and this
> did not happen with the previous version "4.15.0-72-generic".

