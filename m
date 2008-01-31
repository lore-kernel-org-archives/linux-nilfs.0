From: Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Physical block addresses?
Date: Thu, 31 Jan 2008 15:25:05 +0900
Message-ID: <47A169C1.3070001@osrg.net>
References: <196f72b10801280948uc9e1275o6c4bf1bf56cd26c2@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <196f72b10801280948uc9e1275o6c4bf1bf56cd26c2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi, Sivan.

> I am trying to figure out whether NILFS uses physical block addresses
> as pointers in inodes and indirect blocks, but I could not figure this
> out from the papers.
> 
> Does it? If so, I assume that when cleaning a segment and copying live
> data to a new segment, each relocated block causes the propagation of
> dirty blocks (because some other blocks point to the old segment, so
> they need to be modified, and so on. Is that correct?

NILFS version 2 uses virtual block numbers to point to blocks. The
virtual block numbers are translated into physical disk addresses when
they are referenced. This mechanism prevents cascading updates of the
file system when cleaning segments because only the
virtual-to-physical mappings are updated.

Thanks.

-- 
Koji Sato
Open Source Software Computing Project
NTT Cyber Space Laboratories
Nippon Telegraph and Telephone Corporation
