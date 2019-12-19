From: Tomas Hlavaty <tom@logand.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8 in nilfs_segctor_do_construct
Date: Thu, 19 Dec 2019 22:02:32 +0100
Message-ID: <87immckp07.fsf@logand.com>
References: <8736emquds.fsf@logand.com> <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKFNMo=k1wVHOwXhTLEOJ+A-nwmvJ+sN_PPa8kY8fMxrQ4R+Jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Ryusuke,

thanks for your answer.

Ryusuke Konishi <konishi.ryusuke@gmail.com> writes:
> 1) Is the crash reproducible in the environment ?

yes

> 2) Can you mount the corrupted(?) partition from a recent version of
> kernel ?
> 3) Does read-only mount option (-r) work to avoid the crash ?

I'll have access to the computer sometime next week so I'll try this out
and let you know.

Thank you,

Tomas
