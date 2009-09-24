From: "Yann E. MORIN" <yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org>
Subject: [SPAM]  Re:  Forcing GC?
Date: Thu, 24 Sep 2009 18:34:36 +0200
Message-ID: <200909241834.36527.yann.morin.1998@anciens.enib.fr>
References: <C2EAE475-6100-48BA-81D2-7B56E3D8DD6C@me.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <C2EAE475-6100-48BA-81D2-7B56E3D8DD6C-BUHhN+a2lJ4@public.gmane.org>
Content-Disposition: inline
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: Byron Guernsey <bguernsey-BUHhN+a2lJ4@public.gmane.org>

Byron,
All,

On Wednesday 23 September 2009 18:38:00 Byron Guernsey wrote:
> In my application I have to run many capture sets- as many as 1000,  
> with each being as large as about 28GB.  After a capture completes, I  
> can move it off the spool storage and onto a slower mechanical hard  
> disc.  This is intended to free up space on the SSD for the next  
> capture set.
[--SNIP--]
> I know what you're thinking- a RAM drive is really what I need, and I  
> agree.  But a $150 SSD is cheaper than a server-class motherboard and  
> 32GB of ram to use for a ram drive.  So I'm working within a budget  
> and an SSD with NILFS works fine, except for when I need to delete the  
> files and reclaim space.

I don't think you even need a file system for this...

If your capture set is one big file, then directly use the raw device:
- add the user running the capture to the group 'disk'
- have the SSD raw device be group-writeable
- direct your capture output to the raw device
- copy the raw device content to long-term storage (eg with dd)

If you use multiple files for your capture:
- do you know in advance the number of files?
- is this number small (eg. <16)?
- do you know in advance the size of each file?
- if you answered yes to all three questions, then create appropriate
  partitions on your device, and direct each capture "stream" to one
  partition, as presented above.
- if you answered no to any of the above, then you'll indeed need a
  file system.

Maybe unomuting and re-mounting the partition would be a solution,
but you'd need root access, or make a small suid program that does
the mount/umount for you.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| --==< ^_^ >==-- `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
`------------------------------^-------^------------------^--------------------'
