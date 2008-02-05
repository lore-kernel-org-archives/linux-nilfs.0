From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Using nilfs to increase performance of NAND/SSD
	flash devices.
Date: Tue, 05 Feb 2008 21:59:08 +0900
Message-ID: <1202216348.7401.63.camel@localhost.localdomain>
References: <30c6373b0802011231t75a8a00djab3c82b4de3fa928@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <30c6373b0802011231t75a8a00djab3c82b4de3fa928-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Kevin,

On Fri, 2008-02-01 at 12:31 -0800, Kevin Burton wrote:
> 
> Hey guys.
> 
> I'm playing with nilfs2 on an Mtron SSD 32G NAND Flash SATA drive.

We're also preparing for the test on SSD!

> NAND is GREAT for random reads but horrible for random writes.
> 
> A log filesystem fixes this problem because when the disk does random
> writes it
> will just read the block from the previous erase block and wrote a new
> block
> with the data to the end of the drive, thereby simulating sequential
> writes.
> 
> I tested this theory by comparing nilfs2 to XFS on the mtron with a
> sysbenchm
> random write to test.  Sure enough nilfs2 beat out XFS by 8.5x and
> wrote at
> about 50MB/s which is amazingly impressive.

Yes, this is a well-known effect and an age-old application of lfs.
Though the primary motivation of NILFS was not in this use,
I think it's one of interesting matters when considering the recent
rise of the NAND flash devices and their future trends especially
for their increase in the capacity. 

As Chris pointed out, we should once compare lfs-like filesystems
justly because we have some choices for this purpose.

> The problem is that with I used the sysbench OLTP benchmark it was
> only about
> 10% faster than an HDD running XFS.
> 
> Not too impressive.
> 
> The OLTP benchmark simulates a MySQL box doing lots of random DELETE,
> UPDATE,
> and INSERT commands so you end up seeing lots or random writes to the
> disk.

Umm, I don't know the reason why the OLTP benchmark doesn't show 
the expected result.  Does it invoke many synchronous writes? 

NILFS incurs overheads for HDD read, so I'm also concerned with read
performance of SSD.


> Is it possible to disable checkpointing to test my theory?  I'm just
> about to
> dive into the source to test this out but I wanted to post here first
> to get
> your thoughts.

No, I think we cannot disable checkpointing.
But if we have good idea to test your theory, we'll reply later.

Regards,
-- 
Ryusuke Konishi
NILFS team NTT
http://www.nilfs.org/
