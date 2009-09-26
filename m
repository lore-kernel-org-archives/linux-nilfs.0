From: Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 12:32:04 -0400
Message-ID: <4ABE4204.70704@att.net>
References: <4ABE0553.3090502@att.net>	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>	<4ABE0AD7.7000904@att.net>	<debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>	<4ABE13D3.2080809@att.net>	<debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com>	<4ABE2704.6030607@att.net>	<debc30fc0909260815s412ee145xa90e02d9ce4c942f@mail.gmail.com>	<4ABE2E86.5010708@att.net>
	<C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9@me.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <C83C8B9E-C7E0-46B8-913E-6F0C407DE2E9-BUHhN+a2lJ4@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Byron Guernsey wrote:
> Be aware that garbage collection will take quite a while on a full  
> drive to go back to 0 unless you also increase the segments cleaned  
> per run and if you accidentally leave it high it will impact  
> performance.
>
> This is why I had asked about a way to force a full GC with a  
> protection period other than that in the conf file. It seems like  
> quick forced cleanup when a user deletes a lot of files is a common  
> need...
>   

That is a good feature to add - quick full GC with a different
protection period. +1 on that option.

I think I might just to a mkfs in between runs to make sure that
the checkpoints are eliminated. That works for my testing but
it doesn't work for real, live, working file systems.

Jeff
