From: Leandro Lucarella <llucax@gmail.com>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
Date: Sun, 14 Jun 2009 15:13:13 -0300
Message-ID: <20090614181313.GA16597@homero.springfield.home>
References: <20090614013211.GA22552@homero.springfield.home> <20090614.124517.47505469.konishi.ryusuke@gmail.com> <20090614153256.GA4020@homero.springfield.home> <20090615.030245.104791670.konishi.ryusuke@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755225AbZFNSPc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090615.030245.104791670.konishi.ryusuke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org, albertito@blitiri.com.ar, users@nilfs.org

Ryusuke Konishi, el 15 de junio a las 03:02 me escribiste:
[snip]
> > Here is the complete trace:
> > http://pastebin.lugmen.org.ar/4931
> 
> Thank you for your help.
> 
> According to your log, there seems to be a leakage in clear processing
> of the writeback flag on pages.  I will review the error path of log
> writer to narrow down the cause.

Oh! I forgot to tell you that the cleanerd process was not running. When
I mounted the NILFS2 filesystem the cleanerd daemon said:

nilfs_cleanerd[29534]: start
nilfs_cleanerd[29534]: cannot create cleanerd on /dev/loop0
nilfs_cleanerd[29534]: shutdown

I thought I might have an old utilities version and that could be because
of that (since the nilfs website was down I couldn't check), but now
I checked in the backup nilfs website that latest version is 2.0.12 and
I have that (Debian package), so I don't know why the cleanerd failed to
start in the first place.

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
