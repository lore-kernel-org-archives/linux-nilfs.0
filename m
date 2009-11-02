From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: Deadlock with nilfs on 2.6.31.4
Date: Mon, 2 Nov 2009 22:32:45 +0100
Message-ID: <20091102223245.1840d8fd@neptune.home>
References: <20091021203847.26acab0a@neptune.home>
	<20091023.025129.71910838.ryusuke@osrg.net>
	<20091022221939.61c832c2@neptune.home>
	<20091103.020502.126745214.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091103.020502.126745214.ryusuke@osrg.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: users@nilfs.org, linux-fsdevel@vger.kernel.org, ryusuke@osrg.net

Hi Ryusuke Konishi,

On Tue, 03 November 2009 Ryusuke Konishi wrote:
> I found the cause of the hang issue reported on ARM targets.
> The following patch would fix the issue.
>=20
> It resolved hang problem on my Feroceon based Linux box.
>=20
> Could you try if the patch fixes the hang of yours ?
>=20
> Thanks,
> Ryusuke Konishi

Seems to fix the issue here as well, at least collectd now does write
its data to the RRD files as well as to the remote system, no frozen
process yet for 2 and a half hours uptime.

Thanks for the fix,
Bruno

Tested-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> --
> From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
>=20
> nilfs2: fix dirty page accounting leak causing hang at write
>=20
> Some users experienced a consistent hang while using NILFS on
> ARM-based targets.
>=20
> I found this was caused by an underflow of dirty pages counter.  A
> b-tree cache routine was marking page dirty without adjusting page
> account information.
>=20
> This fixes the dirty page accounting leak and resolves the hang on
> arm-based targets.
>=20
> Reported-by: Bruno Premont <bonbons@linux-vserver.org>
> Reported-by: Dunphy, Bill <WDunphy@tandbergdata.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  fs/nilfs2/btnode.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
> index 5941958..435864c 100644
> --- a/fs/nilfs2/btnode.c
> +++ b/fs/nilfs2/btnode.c
> @@ -276,8 +276,7 @@ void nilfs_btnode_commit_change_key(struct
> address_space *btnc, "invalid oldkey %lld (newkey=3D%lld)",
>  				       (unsigned long long)oldkey,
>  				       (unsigned long long)newkey);
> -		if (!test_set_buffer_dirty(obh) &&
> TestSetPageDirty(opage))
> -			BUG();
> +		nilfs_btnode_mark_dirty(obh);
> =20
>  		spin_lock_irq(&btnc->tree_lock);
>  		radix_tree_delete(&btnc->page_tree, oldkey);
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
