From: Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 10:36:52 -0400
Message-ID: <4ABE2704.6030607@att.net>
References: <4ABE0553.3090502@att.net>	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>
	<4ABE0AD7.7000904@att.net>	<debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>
	<4ABE13D3.2080809@att.net>
	<debc30fc0909260715u562bd4b0g747327c3e1a0fe37@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909260715u562bd4b0g747327c3e1a0fe37-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

J=E9r=F4me Poulin wrote:
> On Sat, Sep 26, 2009 at 9:14 AM, Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org> wrote:
>   =

>> Got it - thanks.
>>
>> At the same time, I also hit an out of space message. Why would I
>> get this message? If the checkpoints are just creating a small maker
>> then it shouldn't take much space. Unless of course, a huge number
>> of checkpoints are created.
>>
>> Thanks!
>>
>>     =

> If nilfs_cleanerd is shut down, then the filesystem will fill up until
> there's no room for more data. When you delete data, only the
> nilfs_cleanerd can reclaim the space, which is why you set up a
> protection_period, deleted data will never be overwritten unless
> reclaimed by the cleanerd.
> Here is a program I made to represent the disk in a graphical form,
> you'll see the cleanerd in action:
> http://ticpu.net:8080/~jerome/lssu-gtk.py
>
> You need python-2.4+ with pygtk and nilfs-utils to run the program.
>   =


Cool program - I will definitely try this.

So, let me summarize what I think I should do to test nilfs with
IOzone without the impact of the checkpoints and without filling
up the space.

- Run IOzone without cleanerd running to minimize the
impact of checkpoints on IO performance.
- Assuming I don't fill up the file system, after a run of
IOzone, I need to run cleanerd but put the protection
period to something very small (e.g. 1 second) to reclaim the
space.
- Shut down cleanerd again and run another IOzone test.
(rinse and repeat)

Does this sound about right?

Thanks!

Jeff
