From: Vincent Diepeveen <diep-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: NILFS information request
Date: Wed, 14 Apr 2010 23:01:41 +0200
Message-ID: <F4AFB004-B0AF-40AE-8100-7B41D9E0DC78@xs4all.nl>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="yes"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

hi all,

Read an interesting article online on NILFS suggesting it would be ok  
for fast latency.

Very interesting.

Now my use case is rather simple. It is for read-only of EGTBs.   
(chess endgametablebases).

During a game tree search of (for example) a chessprogram if reaching  
far endgame,
it will go into the file system and do a lot of random reads.

There is 2 types of EGTBs common in use.

One is Nalimov which uses 8 KB blocksizes and those get compressed.  
Average compression factor 4,
so in fact it is usually a 2KB read (not a fixed size). This is a  
compressed 8KB with the compressor from Kadatch (very fast compressor/ 
decompressor).

My own EGTB format is not compressed and fixed size. Currently uses  
64KB blocksize but i can change that very easily
to smaller blocksizes if that's faster for read latency. Of course  
some years ago just focussed at magnetic disks where bandwidth
is optimal with blocks of 128KB+ it was most logical for me to take  
at the time 64KB for the caching. Yet this is a define that
i can change quite easily.

The EGTBs themselves can be substantial big. Total set currently  
1.055TB this is the so called 3-6 men.

They will be heavily used in the world champs computerchess in  
september this year which gets held in Japan.
See www.icga.org

I'm building end of this week a 16 processor machine for 1000 euro  
(opteron 8356 - see ebay for price) and want to test
several hardware with NILFS for its random read latency for the EGTBs.

What latency can i expect at which type of storage?

As what matters is fastest latency. The magnetic disk latency under  
linux is currently too slow for it.

Realize the search itself is at millions of nodes (chesspositions) a  
second and if i can get 50 reads per second from ext4 that's
already a lot. Linux is extremely slow there as usual (windows SEEMS  
faster there, it really is). Currently we're using a jbod of 2 drives.

Seeing up a raid0 now of 2 x 500GB for the entire set, yet we want to  
move to way faster latency hardware as having a worst case in your
software is not funny.

Let's start with SSD, note i cannot afford those things probably, as  
it's supposed to be 75 microseconds latency (hardware wise),
but that is a manufacturer spec and i'm quite familiar with the  
difference between manufacturer spec and reality which is always  
dozens of factors
worse than paper supports...

Next question is implementation, especially for parallel random reads.

What has been achieved there so far with NILFS?

As those 16 cores of course are fulltime busy with the Artificial  
Intelligence engine. As i am a total layman in file systems (not so  
much in datastructures - designed my own
datastructures for book formats and such which is very similar to  
file systems, i had reinvented something similar to Sun's file system  
according to a Sun employee,
for the book datastructure to give an example), i'm very interested  
what already has been implemented for NILFS and what i can expect  
from it.

Let's ask another nasty question: how bugfree is NILFS in its current  
implementation?

Realize i'm only going to do reads from it, not writes at all. The  
only write there is, happens a single time.

Now alignment to the file system, as i happen to have also some flash  
lying around here; most interesting to test the latency of that also  
with NILFS.

What latencies can i expect there from which type of flash using NILFS?

Now of course another nasty thing with most flash hardware is that  
the file systems usually central lock that hardware in a manner that  
no i/o in the entire machine is
possible anymore, especially not on the raid10 drives i've also got  
in the machine, which is painful of course.

I remember copying a terabyte in total for a yankee captain to  
several USB drives (one at a time) with usb 1.1 and it totally locked  
in a central manner the entire file system,
no need to say this took weeks of copying time from my development  
machine, not being able to do anything else with it during that time.

Can NILFS do i/o without locking out other devices?

Especially reads in this case as i won't be writing too much. Writes  
is another subject of course when generating 7 men EGTBs.
But that's another chapter for another time.

Vincent
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
