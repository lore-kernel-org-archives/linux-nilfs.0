Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A224E50A8
	for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 18:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789585154; cv=none; b=oqgsSdyDTrIg57AOURkJH0odT7TtCSC8WfwGI4POf9iws6NAZdG3yjByg9P5St6CU6dEVG2KqFbi0AonKK0EuvkergS+45h74YK2+FGQsLIRXL62SmlLNLEU0raVQfzLk7zhggH/HULp0AKc8JNdqwC5Qq64Q/JLTzrbIMklYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789585154; c=relaxed/simple;
	bh=WRP/MO4i9glSYOkSVQEB6SJj29aypyMJe5xqMLEn+bo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hTiqSh8NgHrRga/OL6HhNhsRA2BYFzKMjGACu2QZ86Z1gaxGNEs81d3iZBYZ6qjtuRPb0DMzOqXZi+U4xqDFW/CEkUUDCFB/VfXlmxozbTAhKeoMzNh1n8HNqCMuvSaVYdJ2rSgn8dIGKrz9o8osD0VaoAv6g+Bp/U99ut1R4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b=sd9i1Zaj; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20251104.gappssmtp.com header.i=@dubeyko-com.20251104.gappssmtp.com header.b="sd9i1Zaj"
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85d43db0c29so12523417b3.2
        for <linux-nilfs@vger.kernel.org>; Wed, 16 Sep 2026 11:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20251104.gappssmtp.com; s=20251104; t=1789585135; x=1790189935; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oZ3GEBBVBD1DUVzmqbpLzdMfAqjtMlGIV3/p1MK/Rhw=;
        b=sd9i1ZajQG/6MGO0DnRj122geLgl1a+ljCMSudiGETDteRRA/S2pATCVkApgq2JtKo
         YmjkN3ANI8AgDHHI0/C/FgroclBaI7GrtlBQ/AfQRY7M0x6M78Vo7oUfGC4dCoGns1LN
         vbdeK8YGlHIeyc4n27VUHQwhbLzWoeHPRTJ0W1t2P40UDCvmnmOsd4hTr630Jt4IZ1Rx
         8X2fA4zEnZNgFE+5alEnLrxHpEhVY02g91jM+P03luzXKYZnLbfFkGI4q65j+n9CM4Q1
         6gY3EzdkUkXMXpia3ZvZJGUaC3lpvhrkq0P380FQ7cX91ROBdXsN41xIwetzoX1MJiu0
         zAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789585135; x=1790189935;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :autocrypt:references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oZ3GEBBVBD1DUVzmqbpLzdMfAqjtMlGIV3/p1MK/Rhw=;
        b=2MyxYtN6HUUt7UnkS5p94sxt/9pE+w6AIcw7UfmkXL/E5cEuF5c0IBsMPpW3Pjd3e5
         jc83AlbNk3FMHynMfgbr2JqPeoX5SuNMVBQ7pevyFEAI2j9INgUR3dabaROPZLSFO0XP
         4+8Oz64UlcLlGGKbi4usFlpFf+eFxiVV/DWrUB+8iJUN7S1/nGSze1kQ1gGa9S6dE0/q
         lc1h/D5aI9npwx1kkiaPbqMeSrSfw2be17fZSlB32nbL0dlMen2jcR1EGXJzPnIjqrMe
         C68wiJEHLgDNi0BhZpqzQeOEqUbUGBX+XBFIj7MgB/jUwm+jlYSlMMI2KIKv0fizj8c8
         4uEw==
X-Gm-Message-State: AFuF++m9KksDQpUgDMV0NE7u9ctef8VDm52350bt1Y9zWtjlB7WRCFl2
	fxx+6SFYm6fZnwGo384lEMGEAslVJmqHFdewJEdh2CKc3UoAwTrppZJqpJHAxL2zuV4=
X-Gm-Gg: AYBFou3F3uL+U2MEQaPbqHF3OtBAh3AysOISvg4NKbTTzuf6PHt+PzLOVQFiIUAMJGE
	nGRgW5IvYwWW+HZinEYpHdhaPo18TaOMzfpeBR94qoI4MguyrfiPqZr1bX/5/Nqg71SQA1Sm/tk
	jtKMO6nlkmAUj448tFzLZNBfvq6kvdk1N64W0oAlgVd0x+5ZRfeRMIY5AkR4UDSgQJ85VNMyRTu
	WkxD43d6IoxR1NXybDjCUwkOuQqkC5LF9TOZw3yH+jpowJQzKk+seN2wiBrJjEtZZSaSAbfyA6r
	i4V5LYBAOzY4K8UEvwmh3NxJm37PEn295FTbm6PV58guyJN40S0BEWi56lOoikOU2KuL6NGnHqy
	/40begKjBkLNV9tIWemzXJ+MekbemFRgkA0+eOBEZxOutZUDuEF9mULTOtNH9vinCdHchTJCFvz
	FSOq4+pkbI1AXewFDqvvAf7X5dAvaYjBiaQV2rGAfV9a+dYboKTUNqsG4LooZ2YBsxxrTcyVV57
	8ALl+XDFzY5FjRlEJpBy0Re/DmMUEXa/aMnh0EWbiLa8MIgfuhrpgz91Qdfu5CEZmJsNornqTDb
	sE6bUJE1INp7jWlOn2iBtSDmgp3FaZBDPUgc8bSyUG+N+nruBeMYu/0wcz6J+t/R
X-Received: by 2002:a05:690c:4dc7:b0:856:b8a6:5e79 with SMTP id 00721157ae682-89224b8ff83mr9859577b3.23.1789585135542;
        Wed, 16 Sep 2026 11:58:55 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:f547:a2c0:72f7:6671? ([2600:1700:6476:1430:f547:a2c0:72f7:6671])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-891f1b27c35sm10936237b3.46.2026.09.16.11.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 11:58:55 -0700 (PDT)
Message-ID: <149f405e0e854092e6aa6470ac7e77f222d90fa0.camel@dubeyko.com>
Subject: Re: [PATCH v2] nilfs2: fix checkpoint root lifetime on sysfs errors
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>, Ryusuke Konishi
	 <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Wed, 16 Sep 2026 11:58:50 -0700
In-Reply-To: <20260915194958.3329611-1-qwe.aldo@gmail.com>
References: <20260915041206.2430937-1-qwe.aldo@gmail.com>
	 <20260915194958.3329611-1-qwe.aldo@gmail.com>
Autocrypt: addr=slava@dubeyko.com; prefer-encrypt=mutual;
 keydata=mQINBGgaTLYBEADaJc/WqWTeunGetXyyGJ5Za7b23M/ozuDCWCp+yWUa2GqQKH40dxRIR
 zshgOmAue7t9RQJU9lxZ4ZHWbi1Hzz85+0omefEdAKFmxTO6+CYV0g/sapU0wPJws3sC2Pbda9/eJ
 ZcvScAX2n/PlhpTnzJKf3JkHh3nM1ACO3jzSe2/muSQJvqMLG2D71ccekr1RyUh8V+OZdrPtfkDam
 V6GOT6IvyE+d+55fzmo20nJKecvbyvdikWwZvjjCENsG9qOf3TcCJ9DDYwjyYe1To8b+mQM9nHcxp
 jUsUuH074BhISFwt99/htZdSgp4csiGeXr8f9BEotRB6+kjMBHaiJ6B7BIlDmlffyR4f3oR/5hxgy
 dvIxMocqyc03xVyM6tA4ZrshKkwDgZIFEKkx37ec22ZJczNwGywKQW2TGXUTZVbdooiG4tXbRBLxe
 ga/NTZ52ZdEkSxAUGw/l0y0InTtdDIWvfUT+WXtQcEPRBE6HHhoeFehLzWL/o7w5Hog+0hXhNjqte
 fzKpI2fWmYzoIb6ueNmE/8sP9fWXo6Av9m8B5hRvF/hVWfEysr/2LSqN+xjt9NEbg8WNRMLy/Y0MS
 p5fgf9pmGF78waFiBvgZIQNuQnHrM+0BmYOhR0JKoHjt7r5wLyNiKFc8b7xXndyCDYfniO3ljbr0j
 tXWRGxx4to6FwARAQABtCZWaWFjaGVzbGF2IER1YmV5a28gPHNsYXZhQGR1YmV5a28uY29tPokCVw
 QTAQoAQQIbAQUJA8JnAAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBFXDC2tnzsoLQtrbBDlc2cL
 fhEB1BQJoGl5PAhkBAAoJEDlc2cLfhEB17DsP/jy/Dx19MtxWOniPqpQf2s65enkDZuMIQ94jSg7B
 F2qTKIbNR9SmsczjyjC+/J7m7WZRmcqnwFYMOyNfh12aF2WhjT7p5xEAbvfGVYwUpUrg/lcacdT0D
 Yk61GGc5ZB89OAWHLr0FJjI54bd7kn7E/JRQF4dqNsxU8qcPXQ0wLHxTHUPZu/w5Zu/cO+lQ3H0Pj
 pSEGaTAh+tBYGSvQ4YPYBcV8+qjTxzeNwkw4ARza8EjTwWKP2jWAfA/ay4VobRfqNQ2zLoo84qDtN
 Uxe0zPE2wobIXELWkbuW/6hoQFPpMlJWz+mbvVms57NAA1HO8F5c1SLFaJ6dN0AQbxrHi45/cQXla
 9hSEOJjxcEnJG/ZmcomYHFneM9K1p1K6HcGajiY2BFWkVet9vuHygkLWXVYZ0lr1paLFR52S7T+cf
 6dkxOqu1ZiRegvFoyzBUzlLh/elgp3tWUfG2VmJD3lGpB3m5ZhwQ3rFpK8A7cKzgKjwPp61Me0o9z
 HX53THoG+QG+o0nnIKK7M8+coToTSyznYoq9C3eKeM/J97x9+h9tbizaeUQvWzQOgG8myUJ5u5Dr4
 6tv9KXrOJy0iy/dcyreMYV5lwODaFfOeA4Lbnn5vRn9OjuMg1PFhCi3yMI4lA4umXFw0V2/OI5rgW
 BQELhfvW6mxkihkl6KLZX8m1zcHitCpWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29Aa
 WJtLmNvbT6JAlQEEwEKAD4WIQRVwwtrZ87KC0La2wQ5XNnC34RAdQUCaBpd7AIbAQUJA8JnAAULCQ
 gHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRA5XNnC34RAdYjFEACiWBEybMt1xjRbEgaZ3UP5i2bSway
 DwYDvgWW5EbRP7JcqOcZ2vkJwrK3gsqC3FKpjOPh7ecE0I4vrabH1Qobe2N8B2Y396z24mGnkTBbb
 16Uz3PC93nFN1BA0wuOjlr1/oOTy5gBY563vybhnXPfSEUcXRd28jI7z8tRyzXh2tL8ZLdv1u4vQ8
 E0O7lVJ55p9yGxbwgb5vXU4T2irqRKLxRvU80rZIXoEM7zLf5r7RaRxgwjTKdu6rYMUOfoyEQQZTD
 4Xg9YE/X8pZzcbYFs4IlscyK6cXU0pjwr2ssjearOLLDJ7ygvfOiOuCZL+6zHRunLwq2JH/RmwuLV
 mWWSbgosZD6c5+wu6DxV15y7zZaR3NFPOR5ErpCFUorKzBO1nA4dwOAbNym9OGkhRgLAyxwpea0V0
 ZlStfp0kfVaSZYo7PXd8Bbtyjali0niBjPpEVZdgtVUpBlPr97jBYZ+L5GF3hd6WJFbEYgj+5Af7C
 UjbX9DHweGQ/tdXWRnJHRzorxzjOS3003ddRnPtQDDN3Z/XzdAZwQAs0RqqXrTeeJrLppFUbAP+HZ
 TyOLVJcAAlVQROoq8PbM3ZKIaOygjj6Yw0emJi1D9OsN2UKjoe4W185vamFWX4Ba41jmCPrYJWAWH
 fAMjjkInIPg7RLGs8FiwxfcpkILP0YbVWHiNAabQoVmlhY2hlc2xhdiBEdWJleWtvIDx2ZHViZXlr
 b0BrZXJuZWwub3JnPokCVAQTAQoAPhYhBFXDC2tnzsoLQtrbBDlc2cLfhEB1BQJoVemuAhsBBQkDw
 mcABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEDlc2cLfhEB1GRwP/1scX5HO9Sk7dRicLD/fxo
 ipwEs+UbeA0/TM8OQfdRI4C/tFBYbQCR7lD05dfq8VsYLEyrgeLqP/iRhabLky8LTaEdwoAqPDc/O
 9HRffx/faJZqkKc1dZryjqS6b8NExhKOVWmDqN357+Cl/H4hT9wnvjCj1YEqXIxSd/2Pc8+yw/KRC
 AP7jtRzXHcc/49Lpz/NU5irScusxy2GLKa5o/13jFK3F1fWX1wsOJF8NlTx3rLtBy4GWHITwkBmu8
 zI4qcJGp7eudI0l4xmIKKQWanEhVdzBm5UnfyLIa7gQ2T48UbxJlWnMhLxMPrxgtC4Kos1G3zovEy
 Ep+fJN7D1pwN9aR36jVKvRsX7V4leIDWGzCdfw1FGWkMUfrRwgIl6i3wgqcCP6r9YSWVQYXdmwdMu
 1RFLC44iF9340S0hw9+30yGP8TWwd1mm8V/+zsdDAFAoAwisi5QLLkQnEsJSgLzJ9daAsE8KjMthv
 hUWHdpiUSjyCpigT+KPl9YunZhyrC1jZXERCDPCQVYgaPt+Xbhdjcem/ykv8UVIDAGVXjuk4OW8la
 nf8SP+uxkTTDKcPHOa5rYRaeNj7T/NClRSd4z6aV3F6pKEJnEGvv/DFMXtSHlbylhyiGKN2Amd0b4
 9jg+DW85oNN7q2UYzYuPwkHsFFq5iyF1QggiwYYTpoVXsw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-15 at 16:49 -0300, Aldo Ariel Panzardo wrote:
> nilfs_find_or_create_root() publishes a new root in the checkpoint
> tree before creating its sysfs object.=C2=A0 If sysfs registration fails,
> the root is freed while it is still reachable from the tree.=C2=A0 A
> concurrent nilfs_lookup_root() can then dereference freed memory.
>=20
> The fix needs the lock to be held across the sysfs call, but
> nilfs_sysfs_create_snapshot_group() can sleep, so the existing
> spinlock is not suitable.
>=20
> Convert ns_cptree_lock from a spinlock to a mutex.=C2=A0 All existing
> callers are in process context (mount, lookup, segctor, recovery),
> and nilfs_put_root() can use refcount_dec_and_mutex_lock() as the
> atomic decrement-and-acquire primitive.
>=20
> With the mutex, nilfs_find_or_create_root() can hold it across the
> sysfs registration and only insert the root into the rbtree after
> sysfs succeeds.=C2=A0 On failure, the root was never visible and can be
> freed after waiting for the kobject release callback to complete.
>=20
> Both the creation error path and the normal removal path must wait
> for the embedded kobject release via wait_for_completion() before
> freeing the container, because kobject_put() does not guarantee
> synchronous release (CONFIG_DEBUG_KOBJECT_RELEASE defers it).
>=20
> Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
> ---
>=20
> Changes in v2:
> =C2=A0 - Convert ns_cptree_lock from spinlock to mutex instead of adding
> =C2=A0=C2=A0=C2=A0 a second lock, as suggested by Viacheslav Dubeyko.=C2=
=A0 Use
> =C2=A0=C2=A0=C2=A0 refcount_dec_and_mutex_lock() in nilfs_put_root().
>=20
> =C2=A0fs/nilfs2/the_nilfs.c | 35 +++++++++++++++++++----------------
> =C2=A0fs/nilfs2/the_nilfs.h |=C2=A0 2 +-
> =C2=A02 files changed, 20 insertions(+), 17 deletions(-)
>=20
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index 7b23e373a1..5bfa853471 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -70,7 +70,7 @@ struct the_nilfs *alloc_nilfs(struct super_block
> *sb)
> =C2=A0	spin_lock_init(&nilfs->ns_inode_lock);
> =C2=A0	spin_lock_init(&nilfs->ns_last_segment_lock);
> =C2=A0	nilfs->ns_cptree =3D RB_ROOT;
> -	spin_lock_init(&nilfs->ns_cptree_lock);
> +	mutex_init(&nilfs->ns_cptree_lock);
> =C2=A0	init_rwsem(&nilfs->ns_segctor_sem);
> =C2=A0	nilfs->ns_sb_update_freq =3D NILFS_SB_FREQ;
> =C2=A0
> @@ -846,7 +846,7 @@ struct nilfs_root *nilfs_lookup_root(struct
> the_nilfs *nilfs, __u64 cno)
> =C2=A0	struct rb_node *n;
> =C2=A0	struct nilfs_root *root;
> =C2=A0
> -	spin_lock(&nilfs->ns_cptree_lock);
> +	mutex_lock(&nilfs->ns_cptree_lock);
> =C2=A0	n =3D nilfs->ns_cptree.rb_node;
> =C2=A0	while (n) {
> =C2=A0		root =3D rb_entry(n, struct nilfs_root, rb_node);
> @@ -857,11 +857,11 @@ struct nilfs_root *nilfs_lookup_root(struct
> the_nilfs *nilfs, __u64 cno)
> =C2=A0			n =3D n->rb_right;
> =C2=A0		} else {
> =C2=A0			refcount_inc(&root->count);
> -			spin_unlock(&nilfs->ns_cptree_lock);
> +			mutex_unlock(&nilfs->ns_cptree_lock);
> =C2=A0			return root;
> =C2=A0		}
> =C2=A0	}
> -	spin_unlock(&nilfs->ns_cptree_lock);
> +	mutex_unlock(&nilfs->ns_cptree_lock);
> =C2=A0
> =C2=A0	return NULL;
> =C2=A0}
> @@ -881,7 +881,7 @@ nilfs_find_or_create_root(struct the_nilfs
> *nilfs, __u64 cno)
> =C2=A0	if (!new)
> =C2=A0		return NULL;
> =C2=A0
> -	spin_lock(&nilfs->ns_cptree_lock);
> +	mutex_lock(&nilfs->ns_cptree_lock);
> =C2=A0
> =C2=A0	p =3D &nilfs->ns_cptree.rb_node;
> =C2=A0	parent =3D NULL;
> @@ -896,7 +896,7 @@ nilfs_find_or_create_root(struct the_nilfs
> *nilfs, __u64 cno)
> =C2=A0			p =3D &(*p)->rb_right;
> =C2=A0		} else {
> =C2=A0			refcount_inc(&root->count);
> -			spin_unlock(&nilfs->ns_cptree_lock);
> +			mutex_unlock(&nilfs->ns_cptree_lock);
> =C2=A0			kfree(new);
> =C2=A0			return root;
> =C2=A0		}
> @@ -909,17 +909,19 @@ nilfs_find_or_create_root(struct the_nilfs
> *nilfs, __u64 cno)
> =C2=A0	atomic64_set(&new->inodes_count, 0);
> =C2=A0	atomic64_set(&new->blocks_count, 0);
> =C2=A0
> -	rb_link_node(&new->rb_node, parent, p);
> -	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
> -
> -	spin_unlock(&nilfs->ns_cptree_lock);
> -
> =C2=A0	err =3D nilfs_sysfs_create_snapshot_group(new);
> =C2=A0	if (err) {
> +		mutex_unlock(&nilfs->ns_cptree_lock);
> +		wait_for_completion(&new->snapshot_kobj_unregister);
> =C2=A0		kfree(new);
> -		new =3D NULL;
> +		return NULL;
> =C2=A0	}
> =C2=A0
> +	rb_link_node(&new->rb_node, parent, p);
> +	rb_insert_color(&new->rb_node, &nilfs->ns_cptree);
> +
> +	mutex_unlock(&nilfs->ns_cptree_lock);
> +
> =C2=A0	return new;
> =C2=A0}
> =C2=A0
> @@ -927,13 +929,14 @@ void nilfs_put_root(struct nilfs_root *root)
> =C2=A0{
> =C2=A0	struct the_nilfs *nilfs =3D root->nilfs;
> =C2=A0
> -	if (refcount_dec_and_lock(&root->count, &nilfs-
> >ns_cptree_lock)) {
> +	if (refcount_dec_and_mutex_lock(&root->count,
> +					&nilfs->ns_cptree_lock)) {
> =C2=A0		rb_erase(&root->rb_node, &nilfs->ns_cptree);
> -		spin_unlock(&nilfs->ns_cptree_lock);
> -
> =C2=A0		nilfs_sysfs_delete_snapshot_group(root);
> -		iput(root->ifile);
> +		wait_for_completion(&root-
> >snapshot_kobj_unregister);

Is it right behavior that we are waiting completion under the lock?
Could we have potential deadlock here? I am feeling slightly bad about
waiting something under the lock.

> +		mutex_unlock(&nilfs->ns_cptree_lock);
> =C2=A0
> +		iput(root->ifile);
> =C2=A0		kfree(root);
> =C2=A0	}
> =C2=A0}
> diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
> index 4776a70f01..074644c64a 100644
> --- a/fs/nilfs2/the_nilfs.h
> +++ b/fs/nilfs2/the_nilfs.h
> @@ -150,7 +150,7 @@ struct the_nilfs {
> =C2=A0
> =C2=A0	/* Checkpoint tree */
> =C2=A0	struct rb_root		ns_cptree;
> -	spinlock_t		ns_cptree_lock;
> +	struct mutex		ns_cptree_lock; /* Protects
> ns_cptree */

I assume that you prefer mutex because of exclusive lock nature. Could
we improve something for the case of rw_semaphore?

Thanks,
Slava.

> =C2=A0
> =C2=A0	/* Dirty inode list */
> =C2=A0	struct list_head	ns_dirty_files;
