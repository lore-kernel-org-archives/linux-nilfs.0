From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Thu, 19 Sep 2013 10:29:50 +0400
Message-ID: <1379572190.2310.9.camel@slavad-ubuntu>
References: <1378221484.4325.51.camel@slavad-ubuntu>
	 <20130905.053518.235784172.konishi.ryusuke@lab.ntt.co.jp>
	 <1378395778.2299.10.camel@slavad-ubuntu>
	 <20130919.030910.27786580.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava@dubeyko.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=eBEs52XFzA7y+M5VYvWIPXGcO63wVrcsCC1QwGAF7ng=;
	b=ZJ4PiER4oqTTaQh802/Mr95w+6fP76qkKTmRinSs65lW5/uAdwemYHAs9hdvkya9uHmN1GqnMTfhQsKl5rYac0Hd/yCUWq2Ik/aQFlZcR5ADiPEtQUoh0wzTszYO1n7n;
In-Reply-To: <20130919.030910.27786580.konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jeromepoulin@gmail.com, devel@antoneliasson.se, fercerpav@gmail.com, hermes@ceres.dti.ne.jp, szarpaj@grubelek.pl, Linux@riotingpacifist.net, zahid.chowdhury@starsolutions.com, freeboy6716@gmail.com, klangga@gmail.com, akpm@linux-foundation.org

Hi Ryusuke,

On Thu, 2013-09-19 at 03:09 +0900, Ryusuke Konishi wrote:

[snip]
> 
> Vyacheslav, could you please test your patch for 1KB-block format to
> make sure ?
> 

Yes, sure. I need to prepare rootfs with 1 KB block size. So, I will
spend some time for preparation, reproducing of the issue and patch
testing.

I will share results of testing.

With the best regards,
Vyacheslav Dubeyko.


