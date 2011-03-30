From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] nilfs2: fix oops due to a bad aops initialization
Date: Wed, 30 Mar 2011 09:47:00 +0200
Message-ID: <4D92DFF4.9030801@fusionio.com>
References: <20110330.132555.158630340.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110330.132555.158630340.ryusuke@osrg.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 2011-03-30 06:25, Ryusuke Konishi wrote:
> I've found a regression of nilfs2 file system in 2.6.39-rc1.
> 
> The recent per-queue plugging removal patch causes kernel oopses in
> nilfs.  The following patch will fix this.
> 
> I'll send it to Linus along with other bug-fixes.

Irk, I guess we need the empty aops then.

You can add my acked-by to the patch, sorry about that.

-- 
Jens Axboe
