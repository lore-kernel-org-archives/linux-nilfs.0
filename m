From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Re: Nilfs features
Date: Tue, 26 May 2009 08:54:47 +0400
Message-ID: <4A1B7617.8010207@0bits.com>
References: <4A1A68E6.50905@0bits.com>
	<20090526.082051.100027806.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090526.082051.100027806.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>, ryusuke-sG5X7nlA6pw@public.gmane.org

Ryusuke Konishi wrote:
>
>> I converted (backup/restore) my home directory onto nilfs2 to test it in
>> anger  (yes i know the caveats about it corrupting all my data, etc, but
>> i'm willing to restore when required).
>
> What happened to you ?
> Anyway, thanks for your interest in nilfs.
> (yeah, I'm trying my best, but I keenly feel it's really tough to keep
> the reliability of the filesystem.  so, please remember the caveat.)

Yes, understood very well, but you also you underestimate your code ;-)
Please keep up the good work. The free world has been waiting for this 
kind of filesystem for a while.

>> So is there a way to temporarily suspend checkpointing with a
>> command and then restart it after the restore has completed ? I
>> think this would be useful also for when you want to have a
>> 'privacy' mode (like firefox/mozilla) where you can suspend
>> checkpointing, start some confidential work, email, browsing etc,
>> and then restart checkpointing and roll back to the previous state.
>
> Is your demand rollback feature or some kind of silent (or invalid by
> default) checkpointing, or both ?

No, not demanding anything. Requesting it as a feature. While your 
design has a very crucial use-case of constant checkpointing, there is 
also a use-case to *suspend* checkpointing (or enable it on demand 
only). As mentioned in my previous example, when restoring to a 
filesystem, or even installing new software, it is extremely unlikely 
that you would want a to go back to a point *inbetween* the time you 
started the install/restore to the time it completed. Say for example 
you are installing a new version of Openoffice which installs

   home:/opt/openoffice.org$ find . ! -type d |wc -l
       4100

4000 odd files. For sure if the software didn't work, crashed, was 
buggy, i would go back completely to the pre-install state and would 
never need any intervening checkpoint. In this case i would suspend 
checkpointing before installing (which may by default create a 
snapshot), and then i'd restart the constant checkpointing after i'd 
finished the install/restore. Please note, i am not comparing nilfs to 
zfs, but zfs doesn't have constant cp (i think) but does have the 
feature i mention, i.e you take snapshots when needed (perhaps via a 
cron job daily, monthly, weekly)


> The checkpointing is essential for nilfs, every write on nilfs
> requires creating a checkpoint by its nature.  But I think it's
> possible to make them inaccessible by default.
>
> Rollback is worth considering.  Yes, I agree.  it actually makes the
> recovery of filesystem state smarter.
>
> It even could be a first step toward realization of the remote
> replication (as discussed before in this mailing list).

Yes, after i posted, i went back on the mailing list and seen the 
request already. Sorry for requesting the feature again.


> I think it needs care because the feature partially invalidate what
> the nilfs stands for.  Maybe 5 seconds checkpoining should be remained
> as default.  But some flexiblity might well be allowed as you pointed
> out.

Agreed, but it wouldn't invalidate what nilfs stood for, it would 
enhance it, but it is your code, so it's your right to decide and i 
respect that.

> Supporting method changing cleaning interval without editing the conf
> file, sounds reasonable (yes, sorry for inconvenience).

No need to apologize.

>> Finally instead of having 5 commands, it'd be nice to have once command
>> with different options (like zfs). So instead have
>>
>> . nilfs checkpoint
>> . nilfs snapshot
>> . nilfs remove
>> . nilfs list
>> . nilfs suspend
>> . nilfs restart
>> etc...
>
> Yeah, I agree reorganizing commands into one 'nilfs' command is
> preferable.  Well, I'll add this to the todo items on the site.

Thanks (my /usr/bin directory seems to be growing exponentially).

> I think it would be nice if the old commands are available through
> symbolic links to this unified command according to user's
> predilection.

Agreed, but why have 5 commands and 5 manpages when you can have 1 of 
each ;-). I think users will get used to it and eventually you can 
delete the symlinks.

Thanks for your responses.
D
